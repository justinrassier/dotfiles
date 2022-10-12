

-- vim.api.nvim_create_autocmd("BufWritePost", {
--   -- pattern = "markdown",
--   group = vim.api.nvim_create_augroup("RunCommandOnSave", {clear = true}),
--   callback = function()
--     -- open a new vertical buffer
--     vim.cmd('vsplit')
--     local win = vim.api.nvim_get_current_win()
--     local buf = vim.api.nvim_create_buf(true, true)
--     vim.api.nvim_win_set_buf(win, buf)
--
--     vim.api.nvim_buf_set_lines(buf, 0, 0, false, {"hello", "world"})
--   end
-- })

local M = {}
function M.find_buf_by_name(name)
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    print(buf_name)
    if buf_name == name then
      return buf
    end
  end
end


-- find buffer with name test-runner
local test_runner_buf = M.find_buf_by_name("test-runner")

print(test_runner_buf)

-- if test_runner_buf ~= nil then
--   print("test-runner buffer exists")
-- else
--   -- open a new vertical buffer
--   vim.cmd('vsplit')
--   local win = vim.api.nvim_get_current_win()
--   test_runner_buf = vim.api.nvim_create_buf(true, true)
--   vim.api.nvim_win_set_buf(win, test_runner_buf)
--   vim.api.nvim_buf_set_name(test_runner_buf, "test-runner")
--
--   -- vim.api.nvim_buf_set_lines(test_runner_buf, 0, 0, false, {"hello", "world"})
--   -- -- set the name of the buffer
-- end








-- set the new buffer to be a split window
