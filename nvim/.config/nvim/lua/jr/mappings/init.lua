local vim = vim
local api = vim.api
local M = {}
function M.map(mode, lhs, rhs, opts)
  local options = {noremap = true, silent = true}
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
function M.mapBuf(buf, mode, lhs, rhs, opts)
  local options = {noremap = true, silent = true}
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_buf_set_keymap(buf, mode, lhs, rhs, options)
end





M.map("n", "<c-p>", "<cmd>lua require('jr.telescope').find_files()<cr>")
M.map("n", "<Leader>gpr", "<cmd>lua require('telescope').extensions.gh.pull_request()<cr>")
M.map("n", "<Leader>gi", "<cmd>lua require('telescope').extensions.gh.issues()<cr>")
M.map("n", "<Leader>a", "<cmd>Telescope live_grep<cr>")
