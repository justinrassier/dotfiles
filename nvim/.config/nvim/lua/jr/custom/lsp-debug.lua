
local ns = vim.api.nvim_create_namespace("InlineTesting")

vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("InlineTesting", {clear = true}),
  pattern = "*.spec.ts",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
    vim.fn.jobstart({"nx", "test", "shared-layout-model", "--json","--outputFile=/tmp/results.json", "--skip-nx-cache"}, {
      stdout_buffered = true,
      cwd = "/Users/justinrassier/dev/cavo",
      on_exit = function()
        -- get current working dircetory
        local cwd = vim.fn.getcwd()
        -- read in JSON file
        local file = io.open("/tmp/results.json", "r")
        if file ~= nil then
          local json = file:read("*all")
          local results = vim.fn.json_decode(json)
          file:close()

          -- get the test results
          local testResults = results.testResults[1].assertionResults

          -- -- make a map of test name to result
          local testMap = {}
          for _, result in ipairs(testResults) do
            -- table.insert(testMap, {name = result.title, status = result.status})
            testMap[result.title] = result.status
          end
          -- print(vim.inspect(testMap))
          -- get current buffer
          vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

          -- for each line in buffer check if it has a test
          local line_num = 0
           for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
             -- get the test name from the it statement
            local test = string.match(line, "it%('(.*)'.*%)")

            if test ~= nil then
              local result = testMap[test]
              if result ~= nil then
                local text = { '✅' }
                if result == "failed" then
                  text = { '❌' }
                end
                vim.api.nvim_buf_set_extmark(bufnr,ns, line_num, 0, { virt_text = { text } })
              end
            end
            line_num = line_num + 1
          end

        end
      end
    })
  end

})


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

-- local M = {}
-- function M.find_buf_by_name(name)
--   local bufs = vim.api.nvim_list_bufs()
--   for _, buf in ipairs(bufs) do
--     local buf_name = vim.api.nvim_buf_get_name(buf)
--     print(buf_name)
--     if buf_name == name then
--       return buf
--     end
--   end
-- end



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
