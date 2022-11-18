local popup = require("plenary.popup")

local M = {}
vim.api.nvim_create_user_command("RunThing", function()
	-- create new vertical split
	vim.cmd("vnew")
end, {})

return M

--
