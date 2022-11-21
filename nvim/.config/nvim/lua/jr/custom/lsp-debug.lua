local popup = require("plenary.popup")
local path = require("plenary.path")

local M = {}
vim.api.nvim_create_user_command("RunThing", function(args)
	vim.notify("Running thing", vim.log.levels.WARN)
end, {})

return M

--
