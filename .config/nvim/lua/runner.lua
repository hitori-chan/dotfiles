local M = { buf = nil, height = 12 }

local function run(cmd, cwd)
	local src = vim.api.nvim_get_current_win()
	local old = M.buf
	local win = old and vim.fn.bufwinid(old) or -1

	if win ~= -1 then
		vim.api.nvim_set_current_win(win)
	else
		vim.cmd(("botright %dsplit"):format(M.height))
	end

	M.buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_win_set_buf(0, M.buf)
	vim.fn.jobstart(cmd, { term = true, cwd = cwd })
	vim.cmd.normal({ "G", bang = true }) -- tail output

	if old and vim.api.nvim_buf_is_valid(old) then
		vim.api.nvim_buf_delete(old, { force = true })
	end
	vim.api.nvim_set_current_win(src)
end

function M.f9(cmd, desc)
	vim.keymap.set("n", "<F9>", function()
		vim.cmd.update()
		run(vim.fn.expandcmd(cmd), vim.fn.expand("%:p:h"))
	end, { buffer = true, desc = desc })
end

return M
