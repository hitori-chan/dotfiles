local M = { buf = nil, height = 12 }

local function ensure_term()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if M.buf and vim.api.nvim_win_get_buf(win) == M.buf then
			return M.buf
		end
	end

	vim.cmd('botright split')
	vim.api.nvim_win_set_height(0, M.height)

	if M.buf and vim.api.nvim_buf_is_valid(M.buf) then
		vim.api.nvim_win_set_buf(0, M.buf)
		return M.buf
	end

	vim.cmd.terminal()
	M.buf = vim.api.nvim_get_current_buf()
	vim.bo[M.buf].bufhidden = 'hide'
	vim.bo[M.buf].buflisted = false
	return M.buf
end

local function send(cmd, cwd)
	local cur = vim.api.nvim_get_current_win()
	local buf = ensure_term()
	local job = vim.b[buf].terminal_job_id

	if not job or vim.fn.jobwait({ job }, 0)[1] ~= -1 then
		vim.cmd.terminal()
		M.buf = vim.api.nvim_get_current_buf()
		vim.bo[M.buf].bufhidden = 'hide'
		vim.bo[M.buf].buflisted = false
		buf = M.buf
		job = vim.b[buf].terminal_job_id
	end

	local full_cmd = cmd
	if cwd and cwd ~= '' then
		full_cmd = string.format('cd %s && %s', vim.fn.shellescape(cwd), cmd)
	end

	vim.api.nvim_chan_send(job, full_cmd .. '\n')

	if vim.api.nvim_win_is_valid(cur) then
		vim.api.nvim_set_current_win(cur)
	end
end

function M.f9(cmd, desc)
	vim.keymap.set('n', '<F9>', function()
		local cwd = vim.fn.expand('%:p:h')
		vim.cmd.write()
		send(vim.fn.expandcmd(cmd), cwd)
	end, { buffer = true, desc = desc })
end

return M
