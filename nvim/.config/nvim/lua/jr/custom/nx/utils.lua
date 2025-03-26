local scan = require("plenary.scandir")
local path = require("plenary.path")
local table_length = require("jr.utils").table_length

local M = {}
local max_depth = 10

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

-- given a path, find the project name by first finding the directory of the nearest project.json file
function M.get_project_name_from_path(current_path)
	local nearest_project_json_directory = find_nearest_file(current_path, ".project.json")
	if nearest_project_json_directory == nil then
		print("No project.json found!")
		return
	end
	return vim.fn.json_decode(vim.fn.readfile(nearest_project_json_directory)).name
end

function M.add_current_file_to_nearest_barrel()
	local current_buffer = vim.api.nvim_buf_get_name(0)
	local nearest_barrel = find_nearest_file(current_buffer, "index%.ts")

	local working_dir = tostring(path:new(nearest_barrel):parent())

	local export_path = path:new(current_buffer):make_relative(working_dir):gsub("%.tsx?$", "")
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

M.find_nearest_file = find_nearest_file

return M
