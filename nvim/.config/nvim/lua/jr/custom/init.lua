local M = {}
local path = require("plenary.path")
local Job = require("plenary.job")
local find_nearest_angular_module = require("jr.custom.utils").find_nearest_angular_module
local find_nearest_ngrx_part = require("jr.custom.utils").find_nearest_ngrx_part
local get_project_name_from_path = require("jr.custom.utils").get_project_name_from_path
local get_relative_path_from_project_name = require("jr.custom.utils").get_relative_path_from_project_name
local load_file_into_buffer = require("jr.custom.utils").load_file_into_buffer

function M.jump_to_angular_component_part(extension)
	-- get file name for the current buffer
	local current_buffer = vim.api.nvim_buf_get_name(0)
	-- get the parts of the component path
	local component_path, component_name, component_extension =
		string.match(current_buffer, "(.-)([^\\/]-%.?([^%.\\/]*))$")

	-- niave replacement of extension with desired destination extension
	local destination_file = string.gsub(component_name, "%." .. component_extension, "%." .. extension)

	-- assemble full path to the new file to navigate to
	local full_destination = component_path .. destination_file

	local exists = vim.fn.filereadable(full_destination)

	-- don't open a buffer if the file doesn't exist since you may end up creating a file without knowing it
	if exists == 0 then
		print("File does not exist!", full_destination)
		return
	end

	load_file_into_buffer(full_destination)
end

function M.jump_to_ngrx_parts(ngrx_part)
	local current_buffer = vim.api.nvim_buf_get_name(0)
	local project_name = get_project_name_from_path(current_buffer)

	if project_name == nil then
		print("Could not find project name")
		return
	end

	local is_data_access = string.find(project_name, "data%-access")
	local found_ngrx_part

	if is_data_access then
		-- if in data-access layer, then jump to nearest ngrx particular
		found_ngrx_part = find_nearest_ngrx_part(current_buffer, ngrx_part)
	else
		-- find the corresponding data-access lib by naming convention
		local data_access_project_name = string.gsub(project_name, "feature", "data%-access")
		data_access_project_name = "shared-" .. data_access_project_name
		local absolute_path_to_project = path:new(get_relative_path_from_project_name(data_access_project_name))
			:absolute()
		found_ngrx_part = find_nearest_ngrx_part(absolute_path_to_project, ngrx_part)
	end
	if found_ngrx_part ~= nil then
		local full_destination = path:new(found_ngrx_part):absolute()
		load_file_into_buffer(full_destination)
	else
		print("Could not find related ngrx part: " .. ngrx_part)
	end
end

function M.jump_to_nearest_module()
	local current_buffer = vim.api.nvim_buf_get_name(0)
	local module_relative_path = find_nearest_angular_module(current_buffer)

	if module_relative_path ~= nil then
		local module_absolute_path = path:new(module_relative_path):absolute()
		load_file_into_buffer(module_absolute_path)
	end
end

function M.open_github_pr()
	Job:new({
		command = "gh",
		args = { "pr", "view", "--web" },
		on_exit = function(j, return_val) end,
	}):sync()
end

function M.open_gh_file()
	-- get current line number
	local line = vim.api.nvim_win_get_cursor(0)[1]
	local filename = vim.api.nvim_buf_get_name(0)
	local relative_path = path:new(filename):make_relative()

	Job:new({
		command = "gh",
		args = { "browse", relative_path .. ":" .. line },
	}):sync()
end

function M.new_scratch_buffer()
	vim.api.nvim_command("enew")
	vim.api.nvim_command("setlocal buftype=nofile")
	vim.api.nvim_command("setlocal bufhidden=hide")
	vim.api.nvim_command("setlocal filetype=json")
	-- go to insert mode
	vim.api.nvim_command("normal i")
end

return M
