local path = require("plenary.path")
local find_nearest_file = require("jr.custom.utils").find_nearest_file
local get_project_name_from_path = require("jr.custom.utils").get_project_name_from_path

local M = {}

-- Add current file to the nearest barrel file
vim.api.nvim_create_user_command("AddToBarrel", function()
	local current_buffer = vim.api.nvim_buf_get_name(0)
	local nearest_barrel = find_nearest_file(current_buffer, "index%.ts")

	local working_dir = tostring(path:new(nearest_barrel):parent())

	local export_path = path:new(current_buffer):make_relative(working_dir):gsub("%.ts$", "")
	local export_string = "export * from './" .. export_path .. "';"
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
end, {})

local inline_testing_augroup = vim.api.nvim_create_augroup("InlineTesting", { clear = true })
local inline_testing_ns = vim.api.nvim_create_namespace("InlineTesting")

-- adds an autocommand to run the test suite on save and mark up using virtual text
vim.api.nvim_create_user_command("AttachToTest", function()
	local current_buffer = vim.api.nvim_buf_get_name(0)
	local project_name = get_project_name_from_path(current_buffer)
	local cmd = {
		"nx",
		"test",
		project_name,
		"--testFile=" .. current_buffer,
		"--json",
		"--outputFile=/tmp/results.json",
		"--skip-nx-cache",
	}
	M.add_test_on_save(cmd)
end, {})
vim.api.nvim_create_user_command("AttachToTestJest", function()
	local current_buffer = vim.api.nvim_buf_get_name(0)
	local cmd = {
		"npx",
		"jest",
		"--testPathPattern=" .. current_buffer,
		"--json",
		"--outputFile=/tmp/results.json",
	}
	M.add_test_on_save(cmd)
end, {})

function M.add_test_on_save(cmd)
	local buf_name = vim.api.nvim_buf_get_name(0)
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = inline_testing_augroup,
		pattern = buf_name,
		callback = function()
			local bufnr = vim.api.nvim_get_current_buf()
			M.clear_namespace_for_current_buffer(bufnr)

			-- add an hour glass to each test line
			local line_num = 0
			for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
				-- get the test name from the it statement
				local test = M.get_matching_it_statements_for_line(line)
				local text = { "⌛" }

				if test ~= nil then
					vim.api.nvim_buf_set_extmark(bufnr, inline_testing_ns, line_num, 0, { virt_text = { text } })
				end
				line_num = line_num + 1
			end

			vim.fn.jobstart(cmd, {
				stdout_buffered = true,
				on_exit = function()
					-- read in JSON file
					local file = io.open("/tmp/results.json", "r")
					if file ~= nil then
						local json = file:read("*all")
						local results = vim.fn.json_decode(json)
						file:close()

						-- get the test results
						local testResults = results.testResults[1].assertionResults

						-- -- make a map of test name to result
						local testMap = {}
						for _, result in ipairs(testResults) do
							-- table.insert(testMap, {name = result.title, status = result.status})
							testMap[result.title] =
								{ status = result.status, error_message = result.failureMessages[1] }
						end

						-- for each line in buffer check if it has a test
						M.clear_namespace_for_current_buffer(bufnr)
						local diagnostics_tbl = {}
						line_num = 0
						for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
							-- get the test name from the it statement
							local test = M.get_matching_it_statements_for_line(line)
							if test ~= nil then
								local result = testMap[test]
								if result ~= nil then
									if result.status == "passed" then
										local text = { "✅" }
										vim.api.nvim_buf_set_extmark(
											bufnr,
											inline_testing_ns,
											line_num,
											0,
											{ virt_text = { text } }
										)
									elseif result.status == "failed" then
										table.insert(diagnostics_tbl, {
											bufnr = bufnr,
											lnum = line_num,
											col = 0,
											end_lnum = line_num,
											end_col = 0,
											severity = vim.diagnostic.severity.ERROR,
											message = "Test Failed: " .. result.error_message,
										})
									end
								end
							end
							line_num = line_num + 1
						end
						vim.diagnostic.set(inline_testing_ns, bufnr, diagnostics_tbl, {})
					end
				end,
			})
		end,
	})
end

-- unnatach the test runner from the buffer and clear the namespace
vim.api.nvim_create_user_command("UnattachInlineTesting", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local buf_name = vim.api.nvim_buf_get_name(bufnr)
	M.clear_namespace_for_current_buffer(bufnr)
	vim.api.nvim_clear_autocmds({ group = inline_testing_augroup, pattern = buf_name })
end, {})

--
-- Private functions
--
function M.get_matching_it_statements_for_line(line)
	return string.match(line, "it%(['\"](.*)['\"].*%)")
end

function M.clear_namespace_for_current_buffer(bufnr)
	vim.api.nvim_buf_clear_namespace(bufnr, inline_testing_ns, 0, -1)
	vim.diagnostic.reset(inline_testing_ns, bufnr)
end
