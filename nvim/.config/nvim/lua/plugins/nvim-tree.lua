return {
	"nvim-tree/nvim-tree.lua",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local nvim_tree = require("nvim-tree")
		nvim_tree.setup({
			sort = {
				sorter = "case_sensitive",
			},
			view = {
				width = 40,
			},
			renderer = {
				group_empty = true,
				highlight_opened_files = "all",
			},
			update_focused_file = {
				enable = true,
			},
			filters = {
				dotfiles = true,
			},
		})

		vim.keymap.set("n", "<c-n>", ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
	end,
}
