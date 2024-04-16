local gh = require("jr.custom.gh")
local nx_utils = require("jr.custom.nx.utils")
local git_stuff = require("jr.custom.git")
local nx = require("jr.custom.nx")
local utils = require("jr.utils")
local jira = require("jr.custom.jira")
local time_tracking = require("jr.custom.time-tracking")
local text_utils = require("jr.utils.text-utils")

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

vim.api.nvim_create_user_command("JROpenGitBlameJiraTicket", function()
	local jira_ticket = git_stuff.get_jira_ticket_from_git_blame()
	if not jira_ticket then
		vim.notify("No Jira ticket found", vim.log.levels.WARN)
		return
	end
	jira.open_ticket_in_browser(jira_ticket)
end, {})

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
vim.api.nvim_create_user_command("JRTimeTrackingClearInsignificantTime", function(opts)
	time_tracking.delete_time_for_tickets_with_less_than_5_min()
end, {})
vim.api.nvim_create_user_command("JRTimeTrackingLogTime", function(opts)
	time_tracking.flush_time_tracking()
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
			-- round up to nearest hour
			hours_worked = math.ceil(hours_worked)

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
vim.api.nvim_create_user_command("JRTimeTrackingLogTimeForAllTickets", function(opts)
	local confirm = vim.fn.input("Log time for all tickets? (y/n): ")
	if confirm ~= "y" then
		return
	end

	local tickets = time_tracking.get_tickets_with_time_worked()
	for _, ticket in ipairs(tickets) do
		local seconds_worked = time_tracking.get_time_worked_for_ticket(ticket)
		local hours_worked = seconds_worked / 60 / 60
		-- round up to nearest hour
		hours_worked = math.ceil(hours_worked)
		jira.log_time_for_issue(ticket, hours_worked)
		print("Logged " .. hours_worked .. " hours for " .. ticket)
	end
	time_tracking.flush_time_tracking()
end, {})

------------------------------------------ PR checking -------------------------------------
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

------------------- Screen Shot ---------------

vim.api.nvim_create_user_command("JRFreeze", function()
	local file_type = vim.bo.filetype
	local full_text = text_utils.get_selected_text()

	-- write the file to /tmp/freeze
	local file = io.open("/tmp/freeze", "w")
	if file == nil then
		print("could not open file")
		return
	end
	file:write(full_text)
	file:close()

	-- call the freeze command
	vim.fn.system("freeze /tmp/freeze -l" .. file_type .. " -o /tmp/freeze.png")

	--  use apple script to copy the image to the clipboard
	vim.fn.system("osascript -e 'set the clipboard to (read (POSIX file \"/tmp/freeze.png\") as TIFF picture)'")

	vim.notify("Image copied to clipboard", vim.log.levels.INFO)
end, {
	range = true,
})

---------- Formatting ----------------
vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})

return M
