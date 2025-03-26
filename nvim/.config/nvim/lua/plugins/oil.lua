return {
	"stevearc/oil.nvim",
	opts = {
		keymaps = {
			["<C-r>"] = "actions.refresh",
			["<C-v>"] = false, --"actions.select_vsplit",
			["<C-l>"] = false,
			["<C-p>"] = false,
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
		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	end,
}
