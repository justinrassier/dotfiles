local tw = require("jr.custom.tailwind")
local gh = require("jr.custom.gh")
local jira = require("jr.custom.jira")

local vim = vim

-- Custom jump around Angular component parts
vim.keymap.set("n", "<leader>jc", "<cmd>lua require('jr.custom.angular').jump_to_angular_component_part('ts')<cr>")
vim.keymap.set("n", "<leader>jt", "<cmd>lua require('jr.custom.angular').jump_to_angular_component_part('html')<cr>")
vim.keymap.set(
	"n",
	"<leader>js",
	"<cmd>lua require('jr.custom.angular').jump_to_angular_component_part('styles.ts')<cr>"
)
vim.keymap.set(
	"n",
	"<leader>jy",
	"<cmd>lua require('jr.custom.angular').jump_to_angular_component_part('stories.ts')<cr>"
)
vim.keymap.set("n", "<leader>jj", "<cmd>lua require('jr.custom.angular').toggle_between_spec_and_file()<cr>")
vim.keymap.set("n", "<leader>jd", "<cmd>lua require('jr.custom.angular').jump_to_mdx_file()<cr>")

vim.keymap.set("n", "<leader><leader>x", function()
	-- run luafile for playground
	vim.cmd("messages clear")
	vim.cmd("luafile ~/.config/nvim/lua/jr/custom/playground.lua")
	vim.cmd("RunThing")
end)

vim.keymap.set("n", "<leader><leader>gc", function()
	nx.run_nx_generator("component")
end, { desc = "Nx: Generate Component" })

-- -- Tailwind
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

-- window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

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

-- Terminal navigation
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Terminal Esc" })
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Terminal Left" })
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { desc = "Terminal Down" })
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { desc = "Terminal Up" })
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { desc = "Terminal Right" })

vim.keymap.set("n", "<leader>nt", function()
    vim.cmd("botright split")
    vim.cmd("resize 12")
    vim.cmd("terminal")
    vim.cmd("startinsert")
end, { desc = "New terminal split" })

vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>cc", "<cmd>lua require('color-converter').to_rgb()<cr>")
