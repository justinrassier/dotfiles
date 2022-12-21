local popup = require("plenary.popup")
local path = require("plenary.path")

local M = {}
M.cached_responses = nil
local ns = vim.api.nvim_create_namespace("playground")
vim.api.nvim_create_user_command("ClearThing", function(args)
	vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
end, {})

vim.api.nvim_create_user_command("RunThing", function(args)
	-- get the current line number
	local line = vim.api.nvim_win_get_cursor(0)[1]
	-- run git blame
	local output = vim.fn.system("git blame -L " .. line .. "," .. line .. " " .. vim.fn.expand("%:p"))

	local commit = output:match("([0-9a-f]+) ")

	if string.match(commit, "00000") ~= nil then
		vim.notify("No commit found", vim.log.levels.WARN)
		return
	end

	-- get the commit message
	local commit_message = vim.fn.system("git log -1 --pretty=%B " .. commit)

	-- get the CAVO ticket number
	local ticket = commit_message:match("CAVO%-[0-9]+")
	local pr_number = commit_message:match("(#%d+)")

	-- build options and their actions
	local options = {}
	local option_number = 1
	if ticket ~= nil then
		table.insert(options, {
			text = option_number .. " Open Jira (" .. ticket .. ")",
			action = function()
				vim.fn.system("open https://adventhp.atlassian.net/browse/" .. ticket)
			end,
		})
		option_number = option_number + 1
	end

	if pr_number ~= nil then
		table.insert(options, {
			text = option_number .. " Open PR (" .. pr_number .. ")",
			action = function()
				vim.fn.system("gh pr view --web " .. pr_number)
			end,
		})
		option_number = option_number + 1
	end

	if commit ~= nil then
		table.insert(options, {
			text = option_number .. " Copy commit hash (" .. commit .. ")",
			action = function()
				vim.fn.setreg("+", commit)
			end,
		})
		option_number = option_number + 1
	end

	local option_text = {}
	for _, option in ipairs(options) do
		table.insert(option_text, option.text)
	end
	local selection = vim.fn.inputlist(option_text)

	if selection ~= 0 then
		options[selection].action()
	end
end, {})

return M

--
