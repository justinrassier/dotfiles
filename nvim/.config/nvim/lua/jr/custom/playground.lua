local popup = require("plenary.popup")
local path = require("plenary.path")

local M = {}
M.cached_responses = nil
local ns = vim.api.nvim_create_namespace("playground")
vim.api.nvim_create_user_command("ClearThing", function(args)
  vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
end, {})

vim.api.nvim_create_user_command("RunThing", function(args)
  local current_buffer = vim.api.nvim_buf_get_name(0)
  local buf_path = path:new(current_buffer)
  local relative_path = buf_path:make_relative()
  local filename = string.match(relative_path, "([^/]+)$")

  local full_destination = nil
  if string.match(filename, ".spec.ts") then
    -- if the current file is a spec file, then jump to the file it is testing
    local file_name = string.match(filename, "(.-)%.spec")
    full_destination = buf_path:parent() .. "/" .. file_name .. ".ts"
  else
    -- if the current file is not a spec file, then jump to the spec file
    local filename_without_ext = string.match(filename, "(.-)%.ts")
    full_destination = buf_path:parent() .. "/" .. filename_without_ext .. ".spec.ts"
  end

  print(full_destination)
  -- local width = vim.fn.winwidth(0)
  -- print("width", width)
  -- local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  --
  -- local max_line_length = 0
  -- for i, line in ipairs(lines) do
  -- 	if #line > max_line_length and i ~= 1 then
  -- 		max_line_length = #line
  -- 	end
  -- end
  --
  -- vim.fn.execute("NvimTreeResize " .. max_line_length)
  -- local line_length = vim.fn.strlen(line)
  -- print(line_length)

  -- get list of highlight groups
  -- local highlights = vim.api.nvim_exec("highlight", true)
  -- print(vim.inspect(highlights))
  -- local bufnr = vim.api.nvim_get_current_buf()
  -- vim.api.nvim_buf_set_extmark(bufnr, ns, 10, 0, {
  -- 	hl_group = "IncSearch",
  -- 	-- end_row = 10,
  -- 	-- end_col = 10,
  -- 	virt_text = { { "hello", "Comment" } },
  -- })
  -- vim.api.nvim_buf_set_extmark(bufnr, inline_testing_ns, line_num, 0, { virt_text = { text } })
  -- -- hit JSON api
  -- local response = M.cached_response
  -- 	or vim.fn.json_decode(vim.fn.system("curl -s https://dog-facts-api.herokuapp.com/api/v1/resources/dogs/all"))
  --
  -- M.cached_response = response
  --
  -- -- get the word under the cursor
  -- local word_under_cursor = vim.fn.expand("<cword>")
  --
  -- -- TODO: find the matching item in the response
  -- local matching_item = response[1]
  --
  -- -- create a buffer and put the matching text in it
  -- local blank_buf = vim.api.nvim_create_buf(false, true)
  -- vim.api.nvim_set_option("wrap", true)
  -- vim.api.nvim_buf_set_lines(blank_buf, 0, -1, false, { matching_item.fact })
  --
  -- -- open up the buffer as a popup relative to the cursor
  -- vim.api.nvim_open_win(blank_buf, true, {
  -- 	relative = "cursor",
  -- 	width = 50,
  -- 	height = 20,
  -- 	row = 0,
  -- 	col = 0,
  -- })
end, {})

return M

--
