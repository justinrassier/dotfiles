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

vim.keymap.set("n", "<leader><leader>x", function()
	-- run luafile for playground
	vim.cmd("luafile ~/.config/nvim/lua/jr/custom/playground.lua")
	vim.cmd("RunThing")
end)

vim.keymap.set("n", "<leader><leader>gc", function()
	nx.run_nx_generator("component")
end, { desc = "Nx: Generate Component" })

vim.keymap.set("n", "<leader><leader>gt", function()
	nx.run_nx_generator("component-store")
end, { desc = "Nx: Generate Component Store" })

vim.keymap.set("n", "<leader><leader>", function()
	nx.run_nx_generator("service")
end, { desc = "Nx: Generate Service" })

vim.keymap.set("n", "<leader><leader>gp", function()
	nx.run_nx_generator("pipe")
end, { desc = "Nx: Generate Pipe" })

vim.keymap.set("n", "<leader><leader>gd", function()
	nx.run_nx_generator("directive")
end, { desc = "Nx: Generate Directive" })

vim.keymap.set("n", "<leader><leader>gy", function()
	nx.run_nx_generator("story")
end, { desc = "Nx: Generate Story" })

-- Tailwind
vim.keymap.set("n", "<leader><leader>tw", function()
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
-- vim.keymap.set("n", "<c-j>", "<c-w><c-j>", { noremap = true })
-- vim.keymap.set("n", "<c-k>", "<c-w><c-k>", { noremap = true })
-- vim.keymap.set("n", "<c-h>", "<c-w><c-h>", { noremap = true })
-- vim.keymap.set("n", "<c-l>", "<c-w><c-l>", { noremap = true })
vim.g.tmux_navigator_no_mappings = 1
vim.keymap.set("n", "<C-j>", ":TmuxNavigateDown<cr>", { silent = true })
vim.keymap.set("n", "<C-k>", ":TmuxNavigateUp<cr>", { silent = true })
vim.keymap.set("n", "<C-h>", ":TmuxNavigateLeft<cr>", { silent = true })
vim.keymap.set("n", "<C-l>", ":TmuxNavigateRight<cr>", { silent = true })

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
vim.keymap.set("n", "<leader><leader>jt", "<cmd>:JestingRunInTerminal<cr>")

-- prettify JSON
vim.keymap.set("n", "<leader>pj", "<cmd>%!jq<cr>")

-- center on up/down
vim.keymap.set("n", "<c-u>", "<c-u>zz")
vim.keymap.set("n", "<c-d>", "<c-d>zz")
