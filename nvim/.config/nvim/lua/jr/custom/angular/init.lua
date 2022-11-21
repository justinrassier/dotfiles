local path = require("plenary.path")
local scan = require("plenary.scandir")
local nx_utils = require("jr.custom.nx.utils")

local M = {}
local max_depth = 5
--
-- find the nearest angular module file by walking up the directory tree
-- looking for a file that matches the pattern *.module.ts
local function find_nearest_angular_module(starting_dir)
	local current_dir = path:new(starting_dir)
	local scan_result
	local count = 1
	-- keep going up directories until you find a `.module.ts` (or stop at max_depth as then something went wrong)
	repeat
		current_dir = current_dir:parent()
		scan_result = scan.scan_dir(current_dir:normalize(), { search_pattern = ".module.ts" })
		count = count + 1
	until #scan_result > 0 or count >= max_depth

	return scan_result[1]
end

local function load_file_into_buffer(file)
	local uri = vim.uri_from_fname(file)
	local new_buff = vim.uri_to_bufnr(uri)
	vim.api.nvim_win_set_buf(0, new_buff)
	vim.fn.execute("edit")
end

local function find_nearest_ngrx_part(starting_dir, ngrx_part)
	local current_dir = path:new(starting_dir)
	local scan_result
	local scan_result_plural
	local count = 1
	local ngrx_part_plural = ngrx_part .. "s"
	-- keep going up directories until you find a `.module.ts` (or stop at 10 as then something went wrong)
	repeat
		current_dir = current_dir:parent()
		scan_result = scan.scan_dir(current_dir:normalize(), { search_pattern = "." .. ngrx_part .. ".ts" })
		scan_result_plural =
			scan.scan_dir(current_dir:normalize(), { search_pattern = "." .. ngrx_part_plural .. ".ts" })
		count = count + 1
	until #scan_result > 0 or #scan_result_plural > 0 or count >= 10

	if #scan_result > 0 then
		return scan_result[1]
	else
		return scan_result_plural[1]
	end
end

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
	local project_name = nx_utils.get_project_name_from_path(current_buffer)

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
		local absolute_path_to_project =
			path:new(nx_utils.get_relative_path_from_project_name(data_access_project_name)):absolute()
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

return M
