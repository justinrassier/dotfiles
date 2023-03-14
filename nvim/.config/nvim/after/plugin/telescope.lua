local vim = vim
local telescope = require("telescope")
local builtIn = require("telescope.builtin")
local actions = require("telescope.actions")
local gh = telescope.load_extension("gh")

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
			},
		},
	},
	extensions = {
		fzy_native = {
			override_generic_sorter = false,
			override_file_sorter = true,
		},
		-- live_grep_args = {
		-- 	max_results = 10r
		-- 	glob_pattern = { "*.md" },
		-- },
	},
})

function M.find_files()
	local cmn_opts = {} --generateOpts({})
	cmn_opts.find_command = { "rg", "--hidden", "--files", "-L", "--glob", "!.git" }
	-- cmn_opts.previewer = false
	-- cmn_opts.layout_strategy = "horizontal"
	cmn_opts.layout_config = { width = 0.8 }
	-- builtIn.find_files(cmn_opts)
	builtIn.find_files(require("telescope.themes").get_dropdown(cmn_opts))
end

vim.keymap.set("n", "<c-p>", function()
	M.find_files()
end, { noremap = true })

vim.keymap.set("n", "<Leader>fr", "<cmd>Telescope lsp_references<cr>")
vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
vim.keymap.set("n", "<Leader>a", function()
	require("telescope").extensions.live_grep_args.live_grep_args(require("telescope.themes").get_dropdown({
		layout_config = { width = 0.8 },
	}))
	-- require("telescope.builtin").live_grep({
	-- 	glob_pattern = { "!*min.js", "!*min.css", "!*min.js.map", "!*min.css.map", "!**/trucode-assets/*" },
	-- })
end)

vim.keymap.set("n", "<Leader>tr", "<cmd>Telescope resume<cr>")
vim.keymap.set("n", "<Leader>b", "<cmd>Telescope buffers<cr>")
vim.keymap.set("n", "<Leader>gb", "<cmd>Telescope git_branches<cr>")

return M
