
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

--
-- return M
