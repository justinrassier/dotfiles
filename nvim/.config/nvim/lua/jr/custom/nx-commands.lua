local path = require'plenary.path'
local Job = require'plenary.job'
local nvim_tree_api = require("nvim-tree.api")
local find_nearest_angular_module = require'jr.custom.utils'.find_nearest_angular_module
local get_project_name_from_path = require'jr.custom.utils'.get_project_name_from_path


local M = {};

function M.run_nx_generator(generator_type)
  local node_path = nvim_tree_api.tree.get_node_under_cursor().absolute_path
  local relative_path = path:new(node_path):make_relative()
  local module_relative_path = find_nearest_angular_module(node_path)
  -- if the module path then we just exit with a message
  if module_relative_path == nil then
    print("No module found!")
    return
  end

  -- get the module name from the module file file
  -- NOTE: this won't work anymore if we switch away from ng-modules. But it works for now
  local project_name = module_relative_path:match("^.+/(.+).module.ts$")

  if generator_type == 'component' then
    local component_name = vim.fn.input("Component name:");
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
    local module_relative_path = find_nearest_angular_module(node_path)

    Job:new({
      command = 'nx',
      args = { 'workspace-generator'
      , 'cavo-component'
      , component_name
      , '--project'
      , project_name
      , '--path'
      , relative_path
      , '--componentType'
      , selected_clean
    },
    cwd = node_path,
    on_exit = function (j, return_val)
      -- print(vim.inspect(j:result()))
      -- don't need to do anything here
    end
  }):sync(10000)

  end

  if generator_type == 'service' then

    local service_name = vim.fn.input("Service name:");
    Job:new({
      command = 'nx',
      args = { 'generate'
      , '@nrwl/angular:service'
      , service_name
      , '--project'
      , project_name
      , '--path'
      , relative_path
      , '--skipTests'
    },
    cwd = node_path,
    on_exit = function (j, return_val)
      -- print(vim.inspect(j:result()))
      -- don't need to do anything here
    end
    }):sync(10000)

  end

    if generator_type == "pipe" then
		local pipe_name = vim.fn.input("Pipe name:")

		Job
			:new({
				command = "npx",
				args = {
					"nx",
					"generate",
					"pipe",
					"--name",
					pipe_name,
					"--project",
					project_name,
					"--path",
					relative_path,
				},
				cwd = node_path,
				on_exit = function(j, return_val)
					print(vim.inspect(j:result()))
					-- don't need to do anything here
				end,
			})
			:sync(10000)
	end

	if generator_type == "directive" then
		local directive_name = vim.fn.input("Directive name:")

		Job
			:new({
				command = "npx",
				args = {
					"nx",
					"generate",
					"directive",
					"--name",
					directive_name,
					"--project",
					project_name,
					"--path",
					relative_path,
				},
				cwd = node_path,
				on_exit = function(j, return_val)
					print(vim.inspect(j:result()))
					-- don't need to do anything here
				end,
			})
			:sync(10000)
	end

  if generator_type == 'component-store' then
    Job:new({
      command = 'npx',
      args = { 
        'nx'
      , 'workspace-generator'
      , 'cavo-component-store'
      , '--projectName'
      , project_name
      , '--path'
      , relative_path
    },
    on_exit = function (j, return_val)
      -- print(vim.inspect(j:result()))
      -- don't need to do anything here
    end
  }):sync(10000)

  end

end



function M.run_nx_test_for_file()
  -- get file name for the current buffer
  local current_buffer = vim.api.nvim_buf_get_name(0)
  local project_name = get_project_name_from_path(current_buffer)

  -- build command string
  local test_command = "nx test " .. project_name .. " --testFile "..current_buffer .." --watch"

  -- execute the nx command in a new terminal buffer
  vim.fn.execute("80 vnew | set winfixheight |  terminal " .. test_command )

end

return M
