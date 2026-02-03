local gh = require("jr.custom.gh")
local nx_utils = require("jr.custom.nx.utils")
local git_stuff = require("jr.custom.git")
local nx = require("jr.custom.nx")
local utils = require("jr.utils")
local jira = require("jr.custom.jira")
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
end, {})

vim.api.nvim_create_user_command("JROpenGitBlameJiraTicket", function()
	local jira_ticket = git_stuff.get_jira_ticket_from_git_blame()
	if not jira_ticket then
		vim.notify("No Jira ticket found", vim.log.levels.WARN)
		return
	end
	jira.open_ticket_in_browser(jira_ticket)
end, {})

------------------------------------------ PR checking -------------------------------------
vim.api.nvim_create_user_command("JRStartCheckingPRs", function(opts)
	gh.get_repo_name_async(function(name)
		-- only do this for my work repo
		if name == "ngm-blocks" then
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
	file_type = vim.fn.input({ default = file_type })
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

vim.api.nvim_create_user_command("JRInlayHints", function()
	vim.lsp.inlay_hint.enable()
end, {
	desc = "Enable Inlay Hints",
})

return M
