local nx = require("jr.custom.nx")
local tw = require("jr.custom.tailwind")
local gh = require("jr.custom.gh")
local jira = require("jr.custom.jira")

local vim = vim

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
	vim.cmd("messages clear")
	vim.cmd("luafile ~/.config/nvim/lua/jr/custom/playground.lua")
	vim.cmd("RunThing")
end)

vim.keymap.set("n", "<leader><leader>gc", function()
	nx.run_nx_generator("component")
end, { desc = "Nx: Generate Component" })

-- vim.keymap.set("v", "<leader><leader>gc", function()
-- 	vim.cmd("JRExtractToComponent")
-- end, { desc = "Nx: Generate Component" })

vim.keymap.set("n", "<leader><leader>gt", function()
	nx.run_nx_generator("component-store")
end, { desc = "Nx: Generate Component Store" })

vim.keymap.set("n", "<leader><leader>gs", function()
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

-- open jira ticket in browser
vim.keymap.set("n", "<leader>gj", function()
	local word = vim.fn.expand("<cWORD>")
	local jira_number = string.match(word, "([A-Z]+-[0-9]+)")
	jira.open_ticket_in_browser(jira_number)
end)

-- new scratch buffer
vim.keymap.set("n", "<leader>ns", function()
	require("jr.custom").new_scratch_buffer()
end)

-- Undo breakpoints to make undo less aggressive
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", "?", "?<c-g>u")
vim.keymap.set("i", "!", "!<c-g>u")
vim.keymap.set("i", "{", "{<c-g>u")
vim.keymap.set("i", "}", "}<c-g>u")
vim.keymap.set("i", "(", "(<c-g>u")
vim.keymap.set("i", ")", ")<c-g>u")

-- quickfix navigation
vim.keymap.set("n", "<leader>cn", ":cn<CR>")
vim.keymap.set("n", "<leader>cp", ":cp<CR>")
vim.keymap.set("n", "<leader>co", ":copen<CR>")
vim.keymap.set("n", "<leader>cl", ":cclose<CR>")
-- close location list as well with the same keymap
vim.keymap.set("n", "<leader>cl", ":lcl<CR>")

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

-- Jesting
vim.keymap.set("n", "<leader><leader>ja", "<cmd>:JestingAttachNx<cr>")
vim.keymap.set("n", "<leader><leader>ju", "<cmd>:JestingUnattach<cr>")
vim.keymap.set("n", "<leader><leader>jc", "<cmd>:JestingCloseConsoleLogWindow<cr>")
vim.keymap.set("n", "<leader><leader>jt", "<cmd>:JestingRunInTerminal<cr>")

-- prettify JSON
vim.keymap.set("n", "<leader>pj", "<cmd>%!jq<cr>")

-- center on up/down
vim.keymap.set("n", "<c-u>", "<c-u>zz")
vim.keymap.set("n", "<c-d>", "<c-d>zz")

-- copy current buffer relative path into clipboard
vim.keymap.set("n", "<leader><leader>cp", "<cmd>let @+ = expand('%:~:.')<CR>")

-- copilot enable/disable
vim.keymap.set("n", "<leader>cd", "<cmd>Copilot disable<cr>")
vim.keymap.set("n", "<leader>ce", "<cmd>Copilot enable<cr>")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>E", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
