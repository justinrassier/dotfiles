local popup = require("plenary.popup")
local path = require("plenary.path")

local M = {}
vim.api.nvim_create_user_command("RunThing", function(args)
	print("args", vim.inspect(args))
	-- get current line number
	-- get current visual selected range
	local start_line, end_line = unpack(vim.api.nvim_buf_get_mark(0, "<"))
	print(start_line, end_line)
end, {})

return M

--
