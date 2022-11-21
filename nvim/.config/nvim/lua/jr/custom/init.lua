local M = {}

function M.new_scratch_buffer()
	vim.api.nvim_command("enew")
	vim.api.nvim_command("setlocal buftype=nofile")
	vim.api.nvim_command("setlocal bufhidden=hide")
	vim.api.nvim_command("setlocal filetype=json")
	-- go to insert mode
	vim.api.nvim_command("normal i")
end

return M
