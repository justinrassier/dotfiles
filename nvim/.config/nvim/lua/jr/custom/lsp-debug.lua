local Job = require'plenary.job'
local api = require("nvim-tree.api")
local scan = require'plenary.scandir'
local path = require'plenary.path'
-- local M = {}
--
-- function M.debug_lsp()
--   print("Hello!!!");
--
-- end
function GlobalFunction()
  local position_params = vim.lsp.util.make_position_params()
  position_params.context = {includeDeclaration = false}

  vim.lsp.buf_request(0, "textDocument/references", position_params, function(err, result, ctx) 

    -- print(err, method,result)
    --
    print(vim.inspect(err))
    print("result")
    print(vim.inspect(result))
    print("ctx")
    print(vim.inspect(ctx))
    -- print(vim.inspect(result))

  end)

end

function table_length(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
--
-- return M
