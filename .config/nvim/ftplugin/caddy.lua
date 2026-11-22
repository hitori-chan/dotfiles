vim.bo.commentstring = "# %s"
vim.bo.expandtab = false

if vim.fn.executable("caddy") == 0 then
	return
end

local ns = vim.api.nvim_create_namespace("caddy")
local group = vim.api.nvim_create_augroup("caddy", { clear = false })

vim.api.nvim_clear_autocmds({ group = group, buffer = 0 })
vim.api.nvim_create_autocmd("BufWritePost", {
	group = group,
	buffer = 0,
	callback = function(ev)
		local path = vim.api.nvim_buf_get_name(ev.buf)
		local name = vim.fs.basename(path)
		vim.system(
			{ "caddy", "adapt", "--config", name },
			{ cwd = vim.fs.dirname(path), text = true },
			vim.schedule_wrap(function(out)
				local diags = {}
				for line in vim.gsplit(out.stderr, "\n", { trimempty = true }) do
					local ok, log = pcall(vim.json.decode, line)
					if ok and type(log) == "table" and (log.level == "error" or log.level == "warn") then
						diags[#diags + 1] = {
							lnum = (log.line or tonumber(log.msg:match(vim.pesc(name) .. ":(%d+)")) or 1) - 1,
							col = 0,
							severity = vim.diagnostic.severity[log.level:upper()],
							message = log.msg,
							source = "caddy",
						}
					end
				end
				if vim.api.nvim_buf_is_valid(ev.buf) then
					vim.diagnostic.set(ns, ev.buf, diags)
				end
			end)
		)
	end,
})
