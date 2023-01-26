local M = {}
function M.git_blame_options()
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
			title = "Open Jira (" .. ticket .. ")",
			action = function()
				vim.fn.system("open https://adventhp.atlassian.net/browse/" .. ticket)
			end,
		})
		option_number = option_number + 1
	end

	if pr_number ~= nil then
		table.insert(options, {
			title = "Open PR (" .. pr_number .. ")",
			action = function()
				vim.fn.system("gh pr view --web " .. string.gsub(pr_number, "#", ""))
			end,
		})
		option_number = option_number + 1
	end

	if commit ~= nil then
		table.insert(options, {
			title = "Copy commit hash (" .. commit .. ")",
			action = function()
				vim.fn.setreg("+", commit)
			end,
		})
		option_number = option_number + 1
	end

	return options
end

return M
