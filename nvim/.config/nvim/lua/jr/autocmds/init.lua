local M = {}
function M.autocmd(event, triggers, operations)
  local cmd = string.format("autocmd %s %s %s", event, triggers, operations)
 vim.cmd(cmd)
end


-- M.autocmd("ColorScheme",  "*",   "lua require('jr.colors').setItalics()")
