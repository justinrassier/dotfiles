local Job = require("plenary.job")
local path = require("plenary.path")
local git = require("jr.custom.git")

local M = {}

function M.open_github_pr()
	Job:new({
		command = "gh",
		args = { "pr", "view", "--web" },
	}):sync()
end

function M.open_pr_by_number(number)
	Job:new({
		command = "gh",
		args = { "pr", "view", number, "--web" },
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

function M.get_base_branch_for_pr()
	local job = Job:new({
		command = "gh",
		args = { "pr", "view", "--json", "baseRefName", "--jq", ".baseRefName" },
	})

	job:sync()

	return job:result()[1]
end

function M.get_pr_number_for_commit(commit)
	local job = Job:new({
		command = "gh",
		args = { "pr", "list", "--state", "merged", "--json", "number,title", "--search=" .. commit },
	})

	job:sync()

	local result = job:result()

	local parsed = vim.fn.json_decode(result)
	return parsed
end

function M.create_pr()
	local pull_request_template = path:new("./.github/pull_request_template.md"):read()
	local ticket = git.get_current_branch():match("CAVO%-[0-9]+")
	pull_request_template =
		string.gsub(pull_request_template, "<!%-%- List any Jira ticket numbers %-%->", ticket .. "\n")

	-- pull_request_template = pull_request_template:gsub("\n", "\\n")
	local title = git.get_current_commit_message():gsub("\n", "")

	local pr_check_job = Job:new({
		command = "gh",
		args = { "pr", "view", "--json", "state", "--jq", ".state" },
	})
	pr_check_job:sync()
	local pr_check = pr_check_job:result()

	if pr_check[1] ~= nil and pr_check[1] ~= "CLOSED" then
		M.open_github_pr()
		return
	end

	local job = Job:new({
		command = "gh",
		args = { "pr", "create", "--title", title, "--body", pull_request_template },
	})
	job:sync()
	local result = job:result()

	if result[1] ~= "" then
		-- open the PR in the browser
		vim.fn.system("open " .. result[1])
	end
end

function M.list_prs_for_review_async(callback)
	local job = Job:new({
		command = "gh",
		args = {
			"pr",
			"list",
			"--search",
			"is:open -reviewed-by:@me -is:draft",
			"--json",
			"number,title,author",
		},
		on_exit = function(j)
			local result = j:result()
			vim.schedule(function()
				local results = vim.fn.json_decode(result[1])

				local final_results = {}
				for _, pr in ipairs(results) do
					if
						pr.author.login == "mgerb"
						or pr.author.login == "nmoll"
						or pr.author.login == "cknightdevelopment"
					then
						table.insert(final_results, pr)
					end
				end

				callback(final_results)
			end)
		end,
	})

	job:start()
end

function M.get_repo_name_async(callback)
	local job = Job:new({
		command = "gh",
		args = { "repo", "view", "--json", "name", "--jq", ".name" },
		on_exit = function(j)
			local result = j:result()
			vim.schedule(function()
				callback(result[1])
			end)
		end,
	})

	job:start()
end

return M
