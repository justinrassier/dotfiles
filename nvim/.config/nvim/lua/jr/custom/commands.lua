local gh = require("jr.custom.gh")
local nx_utils = require("jr.custom.nx.utils")
local git_stuff = require("jr.custom.git")
local nx = require("jr.custom.nx")
local utils = require("jr.utils")
local jira = require("jr.custom.jira")
local time_tracking = require("jr.custom.time-tracking")

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

vim.api.nvim_create_user_command("JRCreatePR", function()
	local created = gh.create_pr()

	if not created then
		vim.notify("No PR created", vim.log.levels.ERROR)
		return
	end

	-- -- Log time for the ticket
	-- local branch_name = git_stuff.get_current_branch()
	-- local ticket = branch_name:match("CAVO%-[0-9]+")
	--
	-- if not ticket then
	-- 	ticket = vim.fn.input("What ticket is this for? (CAVO-XXXX): ")
	-- end
	--
	-- local time_in_hours = vim.fn.input("How long did this take? (in hours): ")
	-- time_in_hours = tonumber(time_in_hours)
	--
	-- jira.log_time_for_issue(ticket, time_in_hours)
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

--
-- Time tracking
--
vim.api.nvim_create_user_command("JRTimeTrackingStart", function(opts)
	gh.get_repo_name_async(function(name)
		-- only do this for my work repo
		if name == "cavo" then
			time_tracking.start_time_tracking()
		end
	end)
end, {})
vim.api.nvim_create_user_command("JRTimeTrackingPrint", function(opts)
	time_tracking.print_ticket_map()
end, {})
vim.api.nvim_create_user_command("JRTimeTrackingFlush", function(opts)
	time_tracking.flush_time_tracking()
end, {})
vim.api.nvim_create_user_command("JRTimeTrackingLogTime", function(opts)
	local current_ticket = git_stuff.get_jira_ticket_from_branch()
	if not current_ticket then
		vim.notify("No ticket found in branch name", vim.log.levels.WARN)
		return
	end
	time_tracking.get_time_worked_for_ticket_async(
		current_ticket,
		vim.schedule_wrap(function(seconds_worked)
			if not seconds_worked then
				vim.notify("No time worked for ticket " .. current_ticket, vim.log.levels.WARN)
				return
			end
			local hours_worked = seconds_worked / 60 / 60
			-- round up to nearest 4 hour increment
			hours_worked = math.ceil(hours_worked / 4) * 4

			local confirm = vim.fn.input("Log " .. hours_worked .. " hours for " .. current_ticket .. "? (y/n): ")
			if confirm ~= "y" then
				return
			end
			jira.log_time_for_issue(current_ticket, hours_worked)
			print("Logged " .. hours_worked .. " hours for " .. current_ticket)
			-- clear out the time tracking for this ticket
			time_tracking.delete_time_for_ticket(current_ticket)
		end)
	)
end, {})

vim.api.nvim_create_user_command("JRStartCheckingPRs", function(opts)
	gh.get_repo_name_async(function(name)
		-- only do this for my work repo
		if name == "cavo" then
			local interval = 1000 * 60 * 10 -- 10 minutes
			local timer = vim.loop.new_timer()
			timer:start(
				0,
				interval,
				vim.schedule_wrap(function()
					gh.list_prs_for_review_async(function(results)
						if utils.table_length(results) > 0 then
							M.pr_count = utils.table_length(results)
							vim.notify(
								"You have " .. utils.table_length(results) .. " PRs to review",
								vim.log.levels.WARN
							)
						else
							M.pr_count = nil
						end
					end)
				end)
			)
		end
	end)
end, {})

return M
