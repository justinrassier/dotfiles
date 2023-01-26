local scan = require("plenary.scandir")
local path = require("plenary.path")
local table_length = require("jr.utils").table_length

-- exported functions
local M = {}
local max_depth = 5

local function find_nearest_project_json(starting_dir)
	local current_dir = path:new(starting_dir)
	local scan_result
	local count = 1
	-- keep going up directories until you find a `.project.json` (or stop at max_depth as then something went wrong)
	repeat
		current_dir = current_dir:parent()
		scan_result = scan.scan_dir(current_dir:normalize(), { search_pattern = ".project.json" })
		count = count + 1
	until table_length(scan_result) > 0 or count >= max_depth

	return scan_result[1]
end
local function find_nearest_file(starting_dir, file_name)
	local current_dir = path:new(starting_dir)
	local scan_result
	local count = 1
	repeat
		current_dir = current_dir:parent()
		scan_result = scan.scan_dir(current_dir:normalize(), { search_pattern = file_name, depth = 2 })
		count = count + 1
	until table_length(scan_result) > 0 or count >= max_depth

	return scan_result[1]
end
M.find_nearest_file = find_nearest_file

-- given a path, find the project name by first finding the directory of the nearest project.json file
-- then using the root angular.json to match the project name to the directory
function M.get_project_name_from_path(current_path)
	local nearest_project_json_directory = find_nearest_project_json(current_path)
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

function M.add_current_file_to_nearest_barrel()
	local current_buffer = vim.api.nvim_buf_get_name(0)
	local nearest_barrel = find_nearest_file(current_buffer, "index%.ts")

	local working_dir = tostring(path:new(nearest_barrel):parent())

	local export_path = path:new(current_buffer):make_relative(working_dir):gsub("%.ts$", "")
	local export_string = "export * from './" .. export_path .. "';\n"
	local nearest_barrel_path = path:new(nearest_barrel):absolute()
	local file = io.open(nearest_barrel_path)
	if file ~= nil then
		-- first check if the export is already there
		local file_contents = file:read("*all")
		file:close()

		-- esacpe the export string for lua patterns
		local escaped_export_string = export_string:gsub("%.", "%%.")
		escaped_export_string = escaped_export_string:gsub("%*", "%%*")
		escaped_export_string = escaped_export_string:gsub("%-", "%%-")

		if string.match(tostring(file_contents), escaped_export_string) == nil then
			-- open a new file handle to actually write to the file since after reading the contents it doesn't seem to write
			local write_file = io.open(nearest_barrel_path, "a")
			if write_file ~= nil then
				write_file:write(export_string)
				write_file:close()
				print("Added export to barrel file (" .. nearest_barrel_path .. ")")
			end
		else
			print("Export already exists in barrel file")
		end
	end
end

return M
