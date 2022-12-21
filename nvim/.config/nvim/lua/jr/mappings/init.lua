local nx = require("jr.custom.nx")
local tw = require("jr.custom.tailwind")
local gh = require("jr.custom.gh")

local vim = vim

-- save to system clipboard shortcuts
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Custom jump around Angular component parts
vim.keymap.set("n", "<leader>jm", "<cmd>lua require('jr.custom.angular').jump_to_nearest_module()<cr>")
vim.keymap.set("n", "<leader>jc", "<cmd>lua require('jr.custom.angular').jump_to_angular_component_part('ts')<cr>")
vim.keymap.set("n", "<leader>jt", "<cmd>lua require('jr.custom.angular').jump_to_angular_component_part('html')<cr>")
vim.keymap.set("n", "<leader>js", "<cmd>lua require('jr.custom.angular').jump_to_angular_component_part('scss')<cr>")
vim.keymap.set("n", "<leader>jj", "<cmd>lua require('jr.custom.angular').toggle_between_spec_and_file()<cr>")

-- Jump to ngrx parts
vim.keymap.set("n", "<leader>jxr", "<cmd>lua require('jr.custom.angular').jump_to_ngrx_parts('reducer')<cr>")
vim.keymap.set("n", "<leader>jxe", "<cmd>lua require('jr.custom.angular').jump_to_ngrx_parts('effect')<cr>")
vim.keymap.set("n", "<leader>jxa", "<cmd>lua require('jr.custom.angular').jump_to_ngrx_parts('action')<cr>")
vim.keymap.set("n", "<leader>jxf", "<cmd>lua require('jr.custom.angular').jump_to_ngrx_parts('facade')<cr>")
vim.keymap.set("n", "<leader>jxs", "<cmd>lua require('jr.custom.angular').jump_to_ngrx_parts('selector')<cr>")
--

-- Call nx generator
vim.keymap.set("n", "<leader>nxgc", function()
	nx.run_nx_generator("component")
end, { desc = "Nx: Generate Component" })

vim.keymap.set("n", "<leader>nxgcs", function()
	nx.run_nx_generator("component-store")
end)

vim.keymap.set("n", "<leader>nxgs", function()
	nx.run_nx_generator("service")
end)

vim.keymap.set("n", "<leader>nxgp", function()
	nx.run_nx_generator("pipe")
end)

vim.keymap.set("n", "<leader>nxgd", function()
	nx.run_nx_generator("directive")
end)

vim.keymap.set("n", "<leader>nxgy", function()
	nx.run_nx_generator("story")
end)

vim.keymap.set("n", "<leader>nxt", function()
	nx.run_nx_test_for_file()
end)

-- Tailwind
vim.keymap.set("n", "<leader>twc", function()
	tw.add_or_insert_class_attribute()
end)

-- open github PR in  browser
vim.keymap.set("n", "<leader>gpr", function()
	gh.open_github_pr()
end)

-- new scratch buffer
vim.keymap.set("n", "<leader>ns", function()
	require("jr.custom").new_scratch_buffer()
end)

-- Window navigation
vim.keymap.set("n", "<c-j>", "<c-w><c-j>")
vim.keymap.set("n", "<c-k>", "<c-w><c-k>")
vim.keymap.set("n", "<c-h>", "<c-w><c-h>")
vim.keymap.set("n", "<c-l>", "<c-w><c-l>")

-- Undo breakpoints to make undo less aggressive
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", "?", "?<c-g>u")
vim.keymap.set("i", "!", "!<c-g>u")
vim.keymap.set("i", "{", "{<c-g>u")
vim.keymap.set("i", "}", "}<c-g>u")
vim.keymap.set("i", "(", "(<c-g>u")
vim.keymap.set("i", ")", ")<c-g>u")

-- gitsigns
vim.keymap.set("n", "<leader>gl", ":Gitsigns toggle_current_line_blame<cr>")
vim.keymap.set("n", "<leader>lg", ":LazyGit<cr>")
vim.keymap.set("n", "<leader>dv", ":DiffviewOpen<cr>")
vim.keymap.set("n", "<leader>dc", ":DiffviewClose<cr>")

-- quickfix navigation
vim.keymap.set("n", "<leader>cn", ":cn<CR>")
vim.keymap.set("n", "<leader>cp", ":cp<CR>")
vim.keymap.set("n", "<leader>co", ":copen<CR>")
vim.keymap.set("n", "<leader>cl", ":cclose<CR>")
vim.keymap.set("n", "<leader>cl", ":cclose<CR>")

-- buffer navigation
vim.keymap.set("n", "<leader>bn", ":bnext<cr>")
vim.keymap.set("n", "<leader>bp", ":bprevious<cr>")

-- paste without writing over register
vim.keymap.set("x", "<leader>p", [["_dP]])
--  move line up/down
vim.keymap.set("i", "<C-j>", "<Esc>:m .+1<CR>==gi")
vim.keymap.set("i", "<C-k>", "<Esc>:m .-2<CR>==gi")
vim.keymap.set("n", "<leader>k", ":m .-2<CR>==")
vim.keymap.set("n", "<leader>j", ":m .+1<CR>==")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- resize window helper
vim.keymap.set("n", "<silent> <Leader>+", ':exe "vertical resize " . (winwidth(0) * 3/2)<CR>')
vim.keymap.set("n", "<silent> <Leader>-", ':exe "vertical resize  " . (winwidth(0) * 2/3)<CR>')

-- copy all to clipboard
-- vim.keymap.set("n", "<leader>cac", ":%y+<cr>")
-- paste from clipboard
vim.keymap.set("n", "<leader>pc", ':norm "+p<cr>')

--Harpoooooooon
vim.keymap.set("n", "<leader>mf", '<cmd>lua require("harpoon.mark").add_file()<cr>')
vim.keymap.set("n", "<leader>mu", '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>')
vim.keymap.set("n", "<leader>mn", '<cmd>lua require("harpoon.ui").nav_next()<cr>')
vim.keymap.set("n", "<leader>mp", '<cmd>lua require("harpoon.ui").nav_prev()<cr>')

-- Jesting
vim.keymap.set("n", "<leader><leader>ja", "<cmd>:JestingAttachNx<cr>")
vim.keymap.set("n", "<leader><leader>jc", "<cmd>:JestingCloseConsoleLogWindow<cr>")
-- prettify JSON
vim.keymap.set("n", "<leader>pj", "<cmd>%!jq<cr>")

-- center on up/down
vim.keymap.set("n", "<c-u>", "<c-u>zz")
vim.keymap.set("n", "<c-d>", "<c-d>zz")
