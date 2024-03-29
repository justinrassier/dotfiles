local curl = require("plenary.curl")

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local git = require("jr.custom.git")
local jira = require("jr.custom.jira")

local M = {}

local function slugify(text)
	local slug = text:lower()
	slug = slug:gsub(" ", "-")
	slug = slug:gsub("[^a-zA-Z0-9%-]", "")
	return slug
end

function M.jira_tickets(opts)
	local json = jira.get_my_jira_tickets()

	local results = {}
	for _, issue in ipairs(json.issues) do
		table.insert(results, { issue.key, issue.fields.summary, issue.fields.status.name })
	end

	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "My JIRA Issues",
			finder = finders.new_table({
				results = results,
				entry_maker = function(entry)
					return {
						value = entry,
						ordinal = entry[1] .. " " .. entry[2],
						display = entry[1] .. " " .. entry[2] .. " (" .. entry[3] .. ")",
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				map({ "i", "n" }, "<c-w>", function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					local jira_number = selection.value[1]
					local url = "https://adventhp.atlassian.net/browse/" .. jira_number
					vim.fn.jobstart("open " .. url, { detach = true })
				end)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					local jira_number = selection.value[1]
					local jira_summary = selection.value[2]
					local branch_name = jira_number .. "-" .. slugify(jira_summary)

					git.fetch()
					git.create_branch_from_main(branch_name)
				end)
				return true
			end,
		})
		:find()
end

return M
