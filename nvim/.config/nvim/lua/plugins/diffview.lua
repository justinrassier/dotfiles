local git = require("jr.custom.git")
local gh = require("jr.custom.gh")
return {
	"sindrets/diffview.nvim",
	event = "VeryLazy",
	config = function()
		vim.keymap.set("n", "<leader>dvo", ":DiffviewOpen<cr>")
		vim.keymap.set("n", "<leader>dvc", ":DiffviewClose<cr>")
		vim.keymap.set("n", "<leader>dvp", function()
			git.fetch()
			local base_ref = gh.get_base_branch_for_pr()
			local current_ref = "HEAD"

			if base_ref == nil then
				base_ref = "main"
			end

			local diff_view_command = "DiffviewOpen " .. "origin/" .. base_ref .. ".." .. current_ref
			vim.cmd(diff_view_command)
		end)
	end,
}
