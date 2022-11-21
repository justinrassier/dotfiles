local Job = require("plenary.job")
local path = require("plenary.path")

local M = {}

function M.open_github_pr()
	Job:new({
		command = "gh",
		args = { "pr", "view", "--web" },
	}):sync()
end

function M.open_gh_file()
	-- get current line number
	local line = vim.api.nvim_win_get_cursor(0)[1]
	local filename = vim.api.nvim_buf_get_name(0)
	local relative_path = path:new(filename):make_relative()

	Job:new({
		command = "gh",
		args = { "browse", relative_path .. ":" .. line },
	}):sync()
end

return M
