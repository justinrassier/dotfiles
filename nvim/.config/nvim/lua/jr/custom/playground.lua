local scan = require("plenary.scandir")
local popup = require("plenary.popup")
local path = require("plenary.path")
local curl = require("plenary.curl")
local nx_utils = require("jr.custom.nx.utils")

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local ts_utils = require("nvim-treesitter.ts_utils")

local test_statement_query = [[
 (expression_statement
   (call_expression
     function: ((identifier) @function_id 
                 (#match? @function_id "it|describe")
               ) @function
     arguments: (arguments 
       (string
         (string_fragment) @fragments
       )
     )
    ) 
   ) 
  ]]

local function get_nearest_function(start_node, type)
	-- local query = vim.treesitter.parse_query("typescript", test_statement_query)
	-- local node_start_row, _, node_end_row, _ = start_node:range()
	-- print(node_start_row, node_end_row)
	-- for id, node, _ in query:iter_captures(start_node, 0, node_start_row - 1, node_end_row + 1) do
	-- 	local capture_name = query.captures[id] -- name of the capture in the query
	-- 	if capture_name == "fragments" then
	-- 		local start_row, start_col, end_row, end_col = node:range()
	-- 		-- get the text within the string
	-- 		local text = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)[1]:sub(start_col + 1, end_col)
	-- 		print(text)
	-- 	end
	-- end
end
local function find_nearest_file(starting_dir, file_name)
	local current_dir = path:new(starting_dir)
	local scan_result
	local count = 1
	repeat
		current_dir = current_dir:parent()
		scan_result = scan.scan_dir(current_dir:normalize(), { search_pattern = file_name, max_depth = 3 })
		count = count + 1
	until #scan_result > 0 or count >= 3

	return scan_result[1]
end
vim.api.nvim_create_user_command("RunThing", function()
	vim.api.nvim_feedkeys("_f.dt(f)i, async()=>{}iO", "n", true)
end, {})

-- Jump to jest snaphost WIP
--
-- vim.api.nvim_create_user_command("RunThing", function()
-- 	local start_node = ts_utils.get_node_at_cursor()
-- 	local query = vim.treesitter.parse_query("typescript", test_statement_query)
--
-- 	local text_strings = {}
-- 	while start_node ~= nil do
-- 		if start_node:type() == "expression_statement" then
-- 			local text = nil
-- 			for id, node, _ in query:iter_captures(start_node, 0) do
-- 				local capture_name = query.captures[id]
-- 				if capture_name == "fragments" and text == nil then
-- 					local start_row, start_col, end_row, end_col = node:range()
-- 					-- get the text within the string
-- 					text = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)[1]:sub(start_col + 1, end_col)
-- 					table.insert(text_strings, text)
-- 				end
-- 			end
-- 		end
-- 		start_node = start_node:parent()
-- 	end
--
-- 	-- go through the table in reverse and concat the strings together
-- 	local final_text = ""
--
-- 	for i = #text_strings, 1, -1 do
-- 		final_text = final_text .. " " .. text_strings[i]
-- 	end
-- 	-- trim the string
-- 	final_text = final_text:match("^%s*(.-)%s*$")
--
-- 	-- get current directory
-- 	local current_file = path:new(vim.api.nvim_buf_get_name(0))
-- 	local current_dir = current_file:parent()
-- 	-- get current file name only
-- 	local filename = string.match(current_file.filename, "([^/]+)$")
-- 	local snap_file = find_nearest_file(current_dir, filename .. ".snap")
-- 	if snap_file == nil then
-- 		print("No snap file found")
-- 		return
-- 	end
--
-- 	local bufnr = vim.fn.bufadd(snap_file)
--
-- 	local found = false
-- 	for i, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
-- 		if line:match(final_text) then
-- 			vim.cmd("edit " .. snap_file)
-- 			vim.api.nvim_win_set_cursor(0, { i, 0 })
-- 			found = true
-- 			break
-- 		end
-- 	end
--
-- 	if not found then
-- 		vim.notify("Could not find snapshot", vim.log.levels.WARN)
-- 	end
-- end, {})

-- vim.api.nvim_create_user_command("RunThing", function(args)
-- 	-- run curl to jira
-- 	-- local jira_url = "https://adventhp.atlassian.net/rest/api/latest/"
--
-- 	-- try reading the config file from the config dir
-- 	local config_file = path:new(vim.fn.stdpath("config")):parent():joinpath("jr/jira_config.json")
--
-- 	-- check if file exists
-- 	local config_json = nil
-- 	if not config_file:exists() then
-- 		-- create the parent directory first if it doesn't exist
-- 		if not config_file:parent():exists() then
-- 			config_file:parent():mkdir()
-- 		end
--
-- 		-- create the JSON file
-- 		local file = io.open(config_file.filename, "w")
-- 		if file ~= nil then
-- 			local user = vim.fn.input("Enter your Jira username: ")
-- 			local auth_key = vim.fn.inputsecret("Enter your Jira auth key: ")
-- 			local jira_url = vim.fn.input("Enter your Jira URL: ")
-- 			local json = string.format(
-- 				[[
--     {
--       "user": "%s",
--       "auth_key": "%s",
--       "jira_url": "%s"
--     }
--     ]],
-- 				user,
-- 				auth_key,
-- 				jira_url
-- 			)
-- 			config_json = vim.fn.json_decode(json)
-- 			file:write(json)
-- 			file:close()
-- 		end
-- 	else
-- 		config_json = vim.fn.json_decode(config_file:read())
-- 	end
--
-- 	local rest_api_url = config_json.jira_url .. "/rest/api/latest"
--
-- 	-- url encode the user
-- 	local search_url = rest_api_url .. "/search"
-- 	-- .. '/search?jql=status=Backlog AND assignee="'
-- 	-- .. config_json.user
-- 	-- .. '"&fields=summary'
--
-- 	local res = curl.request({
-- 		url = search_url,
-- 		query = {
-- 			jql = 'status in (Backlog, "In Progress") AND assignee="' .. config_json.user .. '"',
-- 			fields = "summary",
-- 		},
-- 		auth = config_json.user .. ":" .. config_json.auth_key,
-- 		accept = "application/json",
-- 	})
--
-- 	local results = vim.fn.json_decode(res.body).issues
-- 	vim.fn.setreg("+", vim.fn.json_encode(results))
-- 	--
-- 	-- local curl = io.popen(curl_cmd)
-- 	-- if curl ~= nil then
-- 	-- 	local curl_output = curl:read("*all")
-- 	-- 	curl:close()
-- 	-- 	-- local issues = vim.fn.json_decode(curl_output)
-- 	--
-- 	-- 	print(curl_output)
-- 	--
-- 	-- 	-- print(vim.inspect(issues))
-- 	-- end
--
-- 	-- our picker function: colors
-- 	-- local colors = function(opts)
-- 	-- 	opts = opts or {}
-- 	-- 	pickers
-- 	-- 		.new(opts, {
-- 	-- 			prompt_title = "colors",
-- 	-- 			finder = finders.new_table({
-- 	-- 				results = {
-- 	-- 					{ "red", "#ff0000" },
-- 	-- 					{ "green", "#00ff00" },
-- 	-- 					{ "blue", "#0000ff" },
-- 	-- 				},
-- 	-- 				entry_maker = function(entry)
-- 	-- 					return {
-- 	-- 						value = entry,
-- 	-- 						display = entry[1],
-- 	-- 						ordinal = entry[1],
-- 	-- 					}
-- 	-- 				end,
-- 	-- 			}),
-- 	-- 			sorter = conf.generic_sorter(opts),
-- 	-- 			attach_mappings = function(prompt_bufnr, map)
-- 	-- 				actions.select_default:replace(function()
-- 	-- 					actions.close(prompt_bufnr)
-- 	-- 					local selection = action_state.get_selected_entry()
-- 	-- 					print(vim.inspect(selection))
-- 	-- 					vim.api.nvim_put({ selection[1] }, "", false, true)
-- 	-- 				end)
-- 	-- 				return true
-- 	-- 			end,
-- 	-- 		})
-- 	-- 		:find()
-- 	-- end
--
-- 	-- to execute the function
-- 	-- colors(require("telescope.themes").get_dropdown({}))
-- end, {})

return M

--
