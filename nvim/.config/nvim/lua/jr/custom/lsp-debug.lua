local popup = require("plenary.popup")

local M = {}
vim.api.nvim_create_user_command("RunThing", function()
	-- get current buffer
	local current_win = vim.api.nvim_get_current_win()
	vim.fn.execute("20 vnew")
	local console_log_win = vim.api.nvim_get_current_win()
	local console_log_buf = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_win_set_buf(console_log_win, console_log_buf)
	vim.api.nvim_set_current_win(current_win)

	local lines = { "hello", "world" }
	vim.api.nvim_buf_set_lines(console_log_buf, 0, -1, false, lines)
end, {})

return M

--
