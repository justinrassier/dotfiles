local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local git = require("jr.custom.git")
local gh = require("jr.custom.gh")
local M = {}

function M.list_prs_for_review(opts)
	gh.list_prs_for_review_async(function(prs)
		opts = opts or {}
		pickers
			.new(opts, {
				prompt_title = "PRs for review",
				finder = finders.new_table({
					results = prs,
					entry_maker = function(entry)
						return {
							value = entry,
							ordinal = entry.title,
							display = "["
								.. entry.number
								.. "]"
								.. " "
								.. entry.title
								.. " ("
								.. entry.author.name
								.. ")",
						}
					end,
				}),
				sorter = conf.generic_sorter(opts),
				attach_mappings = function(prompt_bufnr, map)
					actions.select_default:replace(function()
						actions.close(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						gh.open_pr_by_number(selection.value.number)
					end)
					return true
				end,
			})
			:find()
	end)
end

return M
