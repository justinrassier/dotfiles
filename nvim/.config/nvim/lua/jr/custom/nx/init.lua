local path = require("plenary.path")
local Job = require("plenary.job")
local nvim_tree_api = require("nvim-tree.api")
local get_project_name_from_path = require("jr.custom.nx.utils").get_project_name_from_path

local M = {}

function M.run_nx_generator(generator_type, opts)
	local buf = vim.api.nvim_get_current_buf()
	local buf_ft = vim.api.nvim_buf_get_option(buf, "filetype")

	local node_path = nil
	local relative_path = nil

	-- if in nvim tree, get either the parent directory or the directory under the cursor
	-- depending on where you are at
	if buf_ft == "NvimTree" then
		local node = nil
		node = nvim_tree_api.tree.get_node_under_cursor()
		node_path = node.absolute_path

		if node.type == "directory" then
			relative_path = path:new(node_path):make_relative()
		else
			relative_path = path:new(node_path):parent():make_relative()
		end
	else
		-- If not in nvim-tree, just get the directory of the current file
		node_path = vim.fn.expand("%:p")
		relative_path = path:new(node_path):parent():make_relative()
	end

	local project_name = get_project_name_from_path(node_path)

	if generator_type == "component" then
		local component_name = vim.fn.input("Component name:")
		local options = {
			"\nselect a component type:",
			"1. simple",
			"2. route",
			"3. container",
		}

		local selection = vim.fn.inputlist(options)
		-- get selection by index from options
		local selected_option = options[selection + 1]
		-- strip off the number from the string
		local selected_clean = string.gsub(selected_option, "%d%. ", "")

		local job = {
			command = "nx",
			args = {
				"generate",
				"@cavo/workspace-plugin:cavo-component",
				component_name,
				"--project",
				project_name,
				"--path",
				relative_path,
				"--componentType",
				selected_clean,
			},
			on_exit = function(j, return_val)
				-- if we pass in selected text, take that text and put it insie the HTML file that was generated
				local selected_text = ""
				if opts ~= nil and opts.selected_text ~= nil then
					selected_text = opts.selected_text
				end

				-- Look at the output of the nx generator to fine the HTML file that was created. A little hacky, but it works!
				for _, v in pairs(j:result()) do
					if v:find("CREATE .*%.html") then
						local file_path = v:match("CREATE (.*)")
						file_path = path:new(file_path):absolute()
						print("selected_text", selected_text)
						print("file_path", file_path)
						if selected_text ~= "" then
							-- write the contents of selected_text to the file
							local file = io.open(file_path, "w")
							if file == nil then
								print("Could not open file: ", file_path)
								return
							end
							file:write(selected_text)
							file:close()
						end
					end
				end
			end,
		}

		-- register an aucomand for when a file is created

		Job:new(job):sync(10000)
	end

	if generator_type == "service" then
		local service_name = vim.fn.input("Service name:")
		Job:new({
			command = "nx",
			args = {
				"generate",
				"@nrwl/angular:service",
				service_name,
				"--project",
				project_name,
				"--path",
				relative_path,
				"--skipTests",
			},
		}):sync(10000)
	end

	if generator_type == "pipe" then
		local pipe_name = vim.fn.input("Pipe name:")

		Job:new({
			command = "npx",
			args = {
				"nx",
				"generate",
				"@nx/angular:pipe",
				"--name",
				pipe_name,
				"--project",
				project_name,
				"--path",
				relative_path,
			},
			on_exit = function(j, return_val)
				-- print(vim.inspect(j:result()))
				-- don't need to do anything here
			end,
		}):sync(10000)
	end

	if generator_type == "directive" then
		local directive_name = vim.fn.input("Directive name:")

		Job:new({
			command = "npx",
			args = {
				"nx",
				"generate",
				"@nx/angular:directive",
				"--name",
				directive_name,
				"--project",
				project_name,
				"--path",
				relative_path,
			},
		}):sync(10000)
	end

	if generator_type == "component-store" then
		local add_spec = vim.fn.input("Add spec file? (y/n):")
		local add_spec_bool = add_spec == "y" and true or false
		Job:new({
			command = "npx",
			args = {
				"nx",
				"@cavo/workspace-plugin:cavo-component-store",
				"--projectName",
				project_name,
				"--path",
				relative_path,
				"--addSpec",
				tostring(add_spec_bool),
			},
		}):sync(10000)
	end
	if generator_type == "story" then
		Job:new({
			command = "npx",
			args = {
				"nx",
				"@cavo/workspace-plugin:cavo-story",
				"--projectName",
				project_name,
				"--path",
				relative_path,
			},
		}):sync(10000)
	end
end

-- function M.run_nx_test_for_file()
--   -- get file name for the current buffer
--   local current_buffer = vim.api.nvim_buf_get_name(0)
--   local project_name = get_project_name_from_path(current_buffer)
--
--   -- build command string
--   local test_command = "nx test " .. project_name .. " --testFile " .. current_buffer .. " --watch"
--
--   -- execute the nx command in a new terminal buffer
--   vim.fn.execute("80 vnew | terminal " .. test_command)
-- end

return M
