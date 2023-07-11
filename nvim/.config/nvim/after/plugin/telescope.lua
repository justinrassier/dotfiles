local vim = vim
local telescope = require("telescope")
local builtIn = require("telescope.builtin")
local actions = require("telescope.actions")

telescope.load_extension("fzy_native")
telescope.load_extension("node_modules")
telescope.load_extension("live_grep_args")

local M = {}

telescope.setup({
	defaults = {
		layout_config = {
			horizontal = { width = 0.8 },
		},
		-- file_ignore_patterns = {
		-- 	{ "(*min.(js|css))" },
		-- },
		file_sorter = require("telescope.sorters").get_fzy_sorter,
		mappings = {
			i = {
				grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
				["<esc>"] = actions.close,
				["<CR>"] = actions.select_default,
				["<Tab>"] = actions.toggle_selection,
				["<C-f>"] = actions.send_selected_to_qflist + actions.open_qflist,
			},
		},
	},
	extensions = {
		fzy_native = {
			override_generic_sorter = false,
			override_file_sorter = true,
		},
		live_grep_args = {
			max_results = 10,
			glob_pattern = { "*.md" },
		},
	},
})

local simple_theme = require("telescope.themes").get_dropdown({
	winblend = 10,
	border = true,
	previewer = true,
	shorten_path = false,
	layout_config = {
		width = 0.8,
	},
})

function M.find_files()
	local cmn_opts = {}
	cmn_opts.find_command = { "rg", "--hidden", "--files", "-L", "--glob", "!.git" }
	cmn_opts.layout_config = { width = 0.8 }
	builtIn.find_files(require("telescope.themes").get_dropdown(cmn_opts))
end

vim.keymap.set("n", "<c-p>", function()
	M.find_files()
end, { noremap = true })

vim.keymap.set("n", "<Leader>fr", "<cmd>Telescope lsp_references<cr>")

vim.keymap.set("n", "<Leader>a", function()
	local opts = vim.deepcopy(simple_theme)
	opts.glob_pattern =
		{ "!*min.js", "!*min.css", "!*min.js.map", "!*min.css.map", "!**/trucode-assets/*", "!package-lock.json" }
	require("telescope.builtin").live_grep(opts)
end)

vim.keymap.set("n", "<Leader>fa", function()
	local opts = vim.deepcopy(simple_theme)
	require("telescope").extensions.live_grep_args.live_grep_args(opts)
end)

vim.keymap.set({ "n", "v" }, "<Leader>fr", function()
	local opts = vim.deepcopy(simple_theme)
	require("telescope.builtin").grep_string(opts)
end)

vim.keymap.set("n", "<leader>fj", function()
	require("jr.telescope.jira_picker").jira_tickets(require("telescope.themes").get_dropdown({
		layout_config = { width = 0.8 },
	}))
end)
vim.keymap.set("n", "<leader>fpr", function()
	require("jr.telescope.pr_picker").list_prs_for_review(require("telescope.themes").get_dropdown({
		layout_config = { width = 0.8 },
	}))
end)

vim.keymap.set("n", "<Leader>tr", "<cmd>Telescope resume<cr>")
vim.keymap.set("n", "<Leader>fb", "<cmd>Telescope buffers<cr>")

return M
