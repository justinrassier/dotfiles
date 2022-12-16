local Job = require("plenary.job")
local path = require("plenary.path")

local M = {}

function M.open_github_pr()
	Job:new({
		command = "gh",
		args = { "pr", "view", "--web" },
	}):sync()
end

function M.open_gh_file(args)
	-- get current line number
	local filename = vim.api.nvim_buf_get_name(0)
	local relative_path = path:new(filename):make_relative()

	Job:new({
		command = "gh",
		args = { "browse", relative_path .. ":" .. args.line_start .. "-" .. args.line_end },
	}):sync()
end

return M
