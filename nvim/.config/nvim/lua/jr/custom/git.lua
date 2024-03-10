local M = {}

function M.fetch()
	vim.fn.system("git fetch")
end

function M.get_current_branch()
	return vim.fn.system("git rev-parse --abbrev-ref HEAD")
end

function M.get_jira_ticket_from_branch()
	local branch_name = M.get_current_branch()
	return branch_name:match("CAVO%-[0-9]+")
end

function M.get_jira_ticket_from_git_blame()
	local line_number = vim.fn.line(".")
	local file_name = vim.fn.expand("%:p")

	local blame_commit = vim.fn.system(
		"git blame --porcelain -L "
			.. line_number
			.. ","
			.. line_number
			.. " "
			.. file_name
			.. "| awk '{print $1; exit}'"
	)
	blame_commit = string.gsub(blame_commit, "%s+", "")
	--
	local jira_ticket = vim.fn.system("git log --format=%B -n 1 " .. blame_commit)
	jira_ticket = jira_ticket:match("CAVO%-[0-9]+")

	if not jira_ticket then
		print("No Jira ticket found")
		return nil
	end

	return jira_ticket
end

function M.get_current_commit_message()
	return vim.fn.system("git log -1 --pretty=%B")
end

function M.create_branch_from_main(branch_name)
	vim.fn.system("get fetch")
	vim.fn.system("git checkout main")
	vim.fn.system("git pull origin main")
	vim.fn.system("git checkout -b " .. branch_name)
end

return M
