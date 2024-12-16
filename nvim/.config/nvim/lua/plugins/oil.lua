return {
	"stevearc/oil.nvim",
	opts = {
		keymaps = {
			["<C-r>"] = "actions.refresh",
			["<C-v>"] = "actions.select_vsplit",
			["<C-l>"] = false,
			["<C-h>"] = false,
			["<C-s>"] = false,
		},
		view_options = {
			show_hidden = true,
		},
	},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	init = function()
		local dir = require("oil").get_current_dir()
		local is_dir = vim.fn.isdirectory(dir) == 1

		if not is_dir then
			return
		end

		vim.cmd.cd(dir)
		vim.keymap.set("n", "<leader>o", "<cmd>Oil<cr>")
	end,
}
