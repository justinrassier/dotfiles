local nvim_tree = require("nvim-tree")

nvim_tree.setup({
	-- open_on_setup = true,
	view = {
		width = 40,
	},
	renderer = {
		icons = {
			glyphs = {
				default = "",
				symlink = "",
				git = {
					unstaged = "",
					staged = "S",
					unmerged = "",
					renamed = "➜",
					deleted = "",
					untracked = "U",
					ignored = "◌",
				},
				folder = {
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
				},
			},
		},
	},
})

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
vim.keymap.set("n", "<c-n>", "<cmd>:NvimTreeToggle<cr>")
vim.keymap.set("n", "<c-f>", "<cmd>:NvimTreeFindFile<cr>")
vim.keymap.set("n", "<leader>ts", "<cmd>:JRShrinkTreeWidth<cr>")
