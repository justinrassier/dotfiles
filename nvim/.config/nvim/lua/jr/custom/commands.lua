local gh = require("jr.custom.gh")
local nx_utils = require("jr.custom.nx.utils")
local nvim_tree_stuff = require("jr.custom.nvim-tree")
local git_stuff = require("jr.custom.git")
local nx = require("jr.custom.nx")

local M = {}

vim.api.nvim_create_user_command("JROpenFileInGitHub", function(args)
	gh.open_gh_file({ line_start = args.line1, line_end = args.line2 })
end, {
	range = true,
})

vim.api.nvim_create_user_command("JROpenGitHubPR", function()
	gh.open_github_pr()
end, {})

-- Add current file to the nearest barrel file
vim.api.nvim_create_user_command("JRAddToBarrel", function()
	nx_utils.add_current_file_to_nearest_barrel()
end, {})

vim.api.nvim_create_user_command("JRShrinkTreeWidth", function()
	nvim_tree_stuff.shrink_width()
end, {})

vim.api.nvim_create_user_command("JRCreatePR", function()
	gh.create_pr()
end, {})

vim.api.nvim_create_user_command("JRExtractToComponent", function(opts)
	local line_start = opts.line1 - 1
	local line_end = opts.line2

	local selected_lines = vim.api.nvim_buf_get_lines(0, line_start, line_end, false)
	local selected_text = table.concat(selected_lines, "\n")
	nx.run_nx_generator("component", { selected_text = selected_text })
	vim.api.nvim_buf_set_lines(0, line_start, line_end, false, {})
end, {
	range = true,
})

return M
