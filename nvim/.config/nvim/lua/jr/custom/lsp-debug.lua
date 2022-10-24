local parsers = require "nvim-treesitter.parsers"
local ts_utils = require "nvim-treesitter.ts_utils"

vim.api.nvim_create_user_command("RunThing", function()
  local current_position = vim.api.nvim_win_get_cursor(0)

  print("current_position", vim.inspect(current_position))
end, {})
--
