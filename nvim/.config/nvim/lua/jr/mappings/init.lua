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


M.map("i", "jk", "<Esc>", {noremap = false, silent = true})
-- shortcut to save quickly
M.map("n", "<Leader>w", ":w<cr>")
-- save to system clipboard shortcuts
M.map("v", "<Leader>y", '"+y', {noremap = false})
M.map("v", "<Leader>d", '"+d', {noremap = false})
M.map("n", "<Leader>p", '"+p', {noremap = false})
M.map("n", "<Leader>p", '"+P', {noremap = false})
M.map("v", "<Leader>p", '"+p', {noremap = false})
M.map("v", "<Leader>P", '"+P', {noremap = false})


-- nvim-tree
M.map("n", "<c-n>", "<cmd>:NvimTreeToggle<cr>")
M.map("n", "<c-f>", "<cmd>:NvimTreeFindFile<cr>")
  
--telescope mappings
M.map("n", "<c-p>", "<cmd>lua require('jr.telescope').find_files()<cr>")
M.map("n", "<Leader>fr", "<cmd>Telescope lsp_references<cr>")
M.map("n", "<Leader>a", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>")
M.map("n", "<Leader>tr", "<cmd>Telescope resume<cr>")
M.map("n", "<Leader>b", "<cmd>Telescope buffers<cr>")
M.map("n", "<Leader>gpr", "<cmd>lua require('telescope').extensions.gh.pull_request()<cr>")
M.map("n", "<Leader>gb", "<cmd>Telescope git_branches<cr>")


-- Custom jump around Angular component parts
M.map("n", "<leader>jm", "<cmd>lua require('jr.custom').jump_to_nearest_module()<cr>")
M.map("n", "<leader>jc", "<cmd>lua require('jr.custom').jump_to_angular_component_part('ts')<cr>")
M.map("n", "<leader>jt", "<cmd>lua require('jr.custom').jump_to_angular_component_part('html')<cr>")
M.map("n", "<leader>js", "<cmd>lua require('jr.custom').jump_to_angular_component_part('scss')<cr>")
M.map("n", "<leader>jj", "<cmd>lua require('jr.custom').jump_to_angular_component_part('spec%.ts')<cr>")

-- Jump to ngrx parts
M.map("n", "<leader>jxr", "<cmd>lua require('jr.custom').jump_to_ngrx_parts('reducer')<cr>")
M.map("n", "<leader>jxe", "<cmd>lua require('jr.custom').jump_to_ngrx_parts('effect')<cr>")
M.map("n", "<leader>jxa", "<cmd>lua require('jr.custom').jump_to_ngrx_parts('action')<cr>")
M.map("n", "<leader>jxf", "<cmd>lua require('jr.custom').jump_to_ngrx_parts('facade')<cr>")
M.map("n", "<leader>jxs", "<cmd>lua require('jr.custom').jump_to_ngrx_parts('selector')<cr>")
--
-- Call nx generator
M.map("n", "<leader>nxgc", "<cmd>lua require('jr.custom.nx-commands').run_nx_generator('component')<cr>")
M.map("n", "<leader>nxgcs", "<cmd>lua require('jr.custom.nx-commands').run_nx_generator('component-store')<cr>")
M.map("n", "<leader>nxgs", "<cmd>lua require('jr.custom.nx-commands').run_nx_generator('service')<cr>")
M.map("n", "<leader>nxgp", "<cmd>lua require('jr.custom.nx-commands').run_nx_generator('pipe')<cr>")
M.map("n", "<leader>nxgd", "<cmd>lua require('jr.custom.nx-commands').run_nx_generator('directive')<cr>")
M.map("n", "<leader>nxt", "<cmd>lua require('jr.custom.nx-commands').run_nx_test_for_file()<cr>")


-- new scratch buffer
M.map("n", "<leader>ns", "<cmd>lua require('jr.custom').new_scratch_buffer()<cr>")


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

-- gitsigns
M.map("n", "<leader>gl", ":Gitsigns toggle_current_line_blame<cr>")
M.map("n", "<leader>lg", ":LazyGit<cr>")

-- quickfix navigation
M.map("n","<leader>cn", ":cn<CR>")
M.map("n","<leader>cp", ":cp<CR>")
M.map("n","<leader>co", ":copen<CR>")
M.map("n","<leader>cl", ":cclose<CR>")
M.map("n","<leader>cl", ":cclose<CR>")

-- buffer navigation
M.map("n","<leader>bn", ":bnext<cr>")
M.map("n","<leader>bp", ":bprevious<cr>")



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

-- dev start terminal
M.map("n", "<leader>dst", "<cmd>10 new | set winfixheight |  terminal npm run dev:all<cr>")

-- Nx affected commands in new terminal
-- M.map("n", "<leader>nxt", "<cmd>10 new | set winfixheight |  terminal nx affected:test<cr>")
M.map("n", "<leader>nxl", "<cmd>10 new | set winfixheight |  terminal nx affected:lint<cr>")


-- copy all to clipboard
M.map("n", "<leader>cac", ":%y+<cr>")
-- paste from clipboard
M.map("n", "<leader>pc", ":norm \"+p<cr>")




--Harpoooooooon
M.map("n", "<leader>mf", "<cmd>lua require(\"harpoon.mark\").add_file()<cr>")
M.map("n", "<leader>mu", "<cmd>lua require(\"harpoon.ui\").toggle_quick_menu()<cr>")
M.map("n", "<leader>mn", "<cmd>lua require(\"harpoon.ui\").nav_next()<cr>")
M.map("n", "<leader>mp", "<cmd>lua require(\"harpoon.ui\").nav_prev()<cr>")


-- Experimental
-- Bracket completion
-- M.map("i", "{} ", "{}<esc>i<cr><esc>O")
-- while typing delete back a WORD
M.map("n", "<leader>td", "<cmd>VimwikiGoto TODO<cr>")


-- jvim.nvim

M.map("n", "<left>", "<cmd>lua require('jvim').to_parent()<cr>")
M.map("n", "<right>", "<cmd>lua require('jvim').descend()<cr>")
M.map("n", "<up>", "<cmd>lua require('jvim').prev_sibling()<cr>")
M.map("n", "<down>", "<cmd>lua require('jvim').next_sibling()<cr>")
-- nnoremap <left> :lua require("jvim").to_parent()<CR>
-- nnoremap <right> :lua require("jvim").descend()<CR>
-- nnoremap <up> :lua require("jvim").prev_sibling()<CR>
-- nnoremap <down> :lua require("jvim").next_sibling()<CR>
M.map("n", "<leader>dl", "<cmd>lua require('jr.custom.lsp-debug').debug_lsp()<cr>")




-- call vimscript function


-- create new scratch buffer using vim api
--


