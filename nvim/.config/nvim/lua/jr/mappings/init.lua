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



--telescope mappings
M.map("n", "<c-p>", "<cmd>lua require('jr.telescope').find_files()<cr>")
M.map("n", "<Leader>gpr", "<cmd>lua require('telescope').extensions.gh.pull_request()<cr>")
M.map("n", "<Leader>gi", "<cmd>lua require('telescope').extensions.gh.issues()<cr>")
M.map("n", "<Leader>gb", "<cmd>Telescope git_branches<cr>")
M.map("n", "<Leader>a", "<cmd>Telescope live_grep<cr>")


-- Custom jump around Angular component parts
M.map("n", "<leader>jt", "<cmd>lua require('jr.custom').jump_to_angular_component_part('html')<cr>")
M.map("n", "<leader>jc", "<cmd>lua require('jr.custom').jump_to_angular_component_part('ts')<cr>")
M.map("n", "<leader>js", "<cmd>lua require('jr.custom').jump_to_angular_component_part('scss')<cr>")


-- Window navigation
M.map("n", "<c-j>", "<c-w><c-j>")
M.map("n", "<c-k>", "<c-w><c-k>")
M.map("n", "<c-h>", "<c-w><c-h>")
M.map("n", "<c-l>", "<c-w><c-l>")

-- Undo breakpoints to make undo less aggressive
M.map("i", ",", ",<c-g>u")
M.map("i", ".", ".<c-g>u")
M.map("i", "?", "?<c-g>u")
M.map("i", "!", "!<c-g>u")
M.map("i", "{", "{<c-g>u")
M.map("i", "}", "}<c-g>u")
M.map("i", "(", "(<c-g>u")
M.map("i", ")", ")<c-g>u")



-- quickfix navigation
M.map("n","<leader>cn", ":cn<CR>")
M.map("n","<leader>cp", ":cp<CR>")
M.map("n","<leader>co", ":copen<CR>")
M.map("n","<leader>cl", ":cclose<CR>")
M.map("n","<leader>cl", ":cclose<CR>")



-- visual paste but don't replace buffer
M.map("v", "<leader>p", "\"_dp")

-- remap capital Y to highlight to end of line
M.map("n", "Y", "y$")

--  move line up/down
M.map("n", "<leader>k", ":m .-2<CR>==")
M.map("n", "<leader>j", ":m .+1<CR>==")
M.map("i", "<C-j>", "<Esc>:m .+1<CR>==gi")
M.map("i", "<C-k>", "<Esc>:m .-2<CR>==gi")
M.map("v", "K", ":m '<-2<CR>gv=gv")
M.map("v", "J", ":m '>+1<CR>gv=gv")



-- resize window helper
M.map("n","<silent> <Leader>+", ":exe \"vertical resize \" . (winwidth(0) * 3/2)<CR>")
M.map("n","<silent> <Leader>-", ":exe \"vertical resize  \" . (winwidth(0) * 2/3)<CR>")
