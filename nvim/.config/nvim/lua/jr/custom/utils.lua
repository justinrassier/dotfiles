local scan = require("plenary.scandir")
local path = require("plenary.path")
local table_length = require("jr.utils").table_length

-- exported functions
local M = {}

-- internal  functions
local I = {}

function I.find_nearest_project_json(starting_dir)
	local current_dir = path:new(starting_dir)
	local scan_result
	local count = 1
	-- keep going up directories until you find a `.module.ts` (or stop at 10 as then something went wrong)
	repeat
		current_dir = current_dir:parent()
		scan_result = scan.scan_dir(current_dir:normalize(), { search_pattern = ".project.json" })
		count = count + 1
	until table_length(scan_result) > 0 or count >= 10

	return scan_result[1]
end
-- find the nearest angular module file by walking up the directory tree
-- looking for a file that matches the pattern *.module.ts
function M.find_nearest_angular_module(starting_dir)
	local current_dir = path:new(starting_dir)
	local scan_result
	local count = 1
	-- keep going up directories until you find a `.module.ts` (or stop at 10 as then something went wrong)
	repeat
		current_dir = current_dir:parent()
		scan_result = scan.scan_dir(current_dir:normalize(), { search_pattern = ".module.ts" })
		count = count + 1
	until table_length(scan_result) > 0 or count >= 10

	return scan_result[1]
end

function M.find_nearest_file(starting_dir, file_name)
	local current_dir = path:new(starting_dir)
	local scan_result
	local count = 1
	-- keep going up directories until you find a `.module.ts` (or stop at 10 as then something went wrong)
	repeat
		current_dir = current_dir:parent()
		scan_result = scan.scan_dir(current_dir:normalize(), { search_pattern = file_name, depth = 1 })
		count = count + 1
	until table_length(scan_result) > 0 or count >= 10

	return scan_result[1]
end

function M.find_nearest_ngrx_part(starting_dir, ngrx_part)
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
	until table_length(scan_result) > 0 or table_length(scan_result_plural) > 0 or count >= 10

	if table_length(scan_result) > 0 then
		return scan_result[1]
	else
		return scan_result_plural[1]
	end
end

-- given a path, find the project name by first finding the directory of the nearest project.json file
-- then using the root angular.json to match the project name to the directory
function M.get_project_name_from_path(current_path)
	local nearest_project_json_directory = I.find_nearest_project_json(current_path)
	if nearest_project_json_directory == nil then
		print("No project.json found!")
		return
	end
	local project_directory = path:new(nearest_project_json_directory):parent()
	project_directory = path:new(project_directory):make_relative()

	-- read in angular.json file
	local angular_json = vim.fn.json_decode(vim.fn.readfile("angular.json"))

	-- get the project name from the project_directory
	local project_name = nil
	for key, value in pairs(angular_json.projects) do
		if value == project_directory then
			project_name = key
		end
	end

	if project_name == nil then
		print("No project found!")
		return
	end

	return project_name
end

-- find the path to the library directory from the project name
-- by looking it up in the angular.json file
function M.get_relative_path_from_project_name(project_name)
	-- read in angular.json file
	local angular_json = vim.fn.json_decode(vim.fn.readfile("angular.json"))

	-- get the project name from the project_directory
	local project_path = nil
	for key, value in pairs(angular_json.projects) do
		if key == project_name then
			project_path = value
		end
	end

	if project_path == nil then
		print("No project found!")
		return
	end

	return project_path
end

function M.load_file_into_buffer(file)
	local uri = vim.uri_from_fname(file)
	local new_buff = vim.uri_to_bufnr(uri)
	vim.api.nvim_win_set_buf(0, new_buff)
	vim.fn.execute("edit")
end

--DEPRECATED
-- return the name of the project from the module file
-- function M.get_project_name_from_module_file(module_relative_path)
--   return module_relative_path:match("^.+/(.+).module.ts$")
-- end

return M
