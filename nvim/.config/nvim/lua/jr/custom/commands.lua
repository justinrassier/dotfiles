local gh = require("jr.custom.gh")
local nx_utils = require("jr.custom.nx.utils")

local M = {}

vim.api.nvim_create_user_command("JROpenFileInGitHub", function()
	gh.open_gh_file()
end, {})

vim.api.nvim_create_user_command("JROpenGitHubPR", function()
	gh.open_github_pr()
end, {})

-- Add current file to the nearest barrel file
vim.api.nvim_create_user_command("JRAddToBarrel", function()
	nx_utils.add_current_file_to_nearest_barrel()
end, {})

return M
