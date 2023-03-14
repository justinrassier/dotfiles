
-- local project_map = {}
-- local function get_project_map()
--   if table_length(project_map) > 0 then
--     return project_map
--   end
--
--   local cwd = path:new(vim.fn.getcwd())
--   local project_files = scan.scan_dir(cwd:normalize(), { search_pattern = "project.json", respect_gitignore = true })
--   for _, project_file in ipairs(project_files) do
--     -- read the file in as JSON and get the name
--     local project_name = vim.fn.json_decode(vim.fn.readfile(project_file)).name
--     project_map[project_name] = path:new(project_file):parent():normalize()
--   end
--
--   return project_map
-- end
--
-- M.prime_project_map = function()
--   if table_length(project_map) > 0 then
--     return
--   end
--   local cwd = path:new(vim.fn.getcwd())
--   -- print(vim.inspect(scan.scan_dir_async))
--   scan.scan_dir_async(cwd:normalize(), {
--     search_pattern = "project.json",
--     respect_gitignore = true,
--     on_insert = vim.schedule_wrap(function(result)
--       -- -- read the file in as JSON and get the name
--       local project_name = vim.fn.json_decode(vim.fn.readfile(result)).name
--       project_map[project_name] = path:new(result):parent():normalize()
--     end),
--     on_exit = function()
--     end,
--   })
-- end
--
