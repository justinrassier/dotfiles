local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local M = {}

function M.list_shell_history(opts)
	opts = opts or {}
	local history_cmd = "cat /Users/justinrassier/.zsh_history | awk -F';' '{print $2}'"
	local history = vim.fn.systemlist(history_cmd)
	-- reverse the history so that the most recent commands are at the top
	history = reverseTable(history)

	pickers
		.new(opts, {
			prompt_title = "History",
			finder = finders.new_table({
				results = history,
				entry_maker = function(entry)
					return {
						value = entry,
						ordinal = entry,
						display = entry,
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					-- copy the selection to the clipboard
					vim.fn.setreg("+", selection.value)
				end)
				return true
			end,
		})
		:find()
end

function reverseTable(inputTable)
	local reversedTable = {}
	local length = #inputTable

	for i = length, 1, -1 do
		table.insert(reversedTable, inputTable[i])
	end

	return reversedTable
end

return M
