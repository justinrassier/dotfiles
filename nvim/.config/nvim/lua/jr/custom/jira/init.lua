local curl = require("plenary.curl")

local M = {}

local function get_api_key()
	local API_KEY = vim.fn.getenv("JIRA_API_KEY")
	if not API_KEY then
		print("JIRA_API_KEY not set")
		return
	end
	return API_KEY
end

function M.log_time_for_issue(jira_issue, time_in_hours)
	local API_KEY = get_api_key()

	local time_in_seconds = time_in_hours * 3600
	local res = curl.request({
		url = "https://adventhp.atlassian.net/rest/api/latest/issue/" .. jira_issue .. "/worklog",
		method = "post",
		auth = "jrassier@adventhp.com:" .. API_KEY,
		headers = {
			content_type = "application/json",
		},
		body = vim.fn.json_encode({ timeSpentSeconds = time_in_seconds, comment = "Work Logged" }),
	})

	if res.status == 201 then
		vim.notify("Work logged", vim.log.levels.INFO)
	else
		vim.notify("Error logging work", vim.log.levels.ERROR)
	end
end

function M.get_my_jira_tickets()
	local API_KEY = get_api_key()

	local res = curl.request({
		url = "https://adventhp.atlassian.net/rest/api/latest/search?jql=assignee='jrassier@adventhp.com'%20AND%20status%20in%20(Backlog,'In%20Progress','In%20Review')&fields=summary,status",
		method = "get",
		auth = "jrassier@adventhp.com:" .. API_KEY,
		accept = "application/json",
	}).body

	local json = vim.fn.json_decode(res)

	return json
end

function M.open_ticket_in_browser(jira_number)
	local url = "https://adventhp.atlassian.net/browse/" .. jira_number
	vim.fn.jobstart("open " .. url, { detach = true })
end

return M
