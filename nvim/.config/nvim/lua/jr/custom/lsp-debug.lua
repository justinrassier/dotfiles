local popup = require("plenary.popup")

local M = {}
vim.api.nvim_create_user_command("RunThing", function()
	-- creat a new buffer
	local bufnr = vim.api.nvim_create_buf(false, true)
	-- add a line of text
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "hello world", "hello world", "hello world" })

	local width = 125
	local height = 25
	local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
	-- open a window in the center of the screen
	local Harpoon_win_id, win = popup.create(bufnr, {
		title = "Test Results",
		line = math.floor(((vim.o.lines - height) / 2) - 1),
		col = math.floor((vim.o.columns - width) / 2),
		minwidth = width,
		minheight = height,
		borderchars = borderchars,
	})
	-- capture enter key

	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<CR>",
		"<Cmd>lua require('jr.custom.lsp-debug').select_menu_item()<CR>",
		{}
	)
end, {})

function M.select_menu_item()
	local line_num = vim.fn.line(".")
	print(line_num)
end

return M

--
