local scan = require("plenary.scandir")
local Job = require("plenary.job")
local path = require("plenary.path")
local curl = require("plenary.curl")
local nx_utils = require("jr.custom.nx.utils")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local ts_utils = require("nvim-treesitter.ts_utils")
local gh = require("jr.custom.gh")
local git = require("jr.custom.git")
local popup = require("plenary.popup")
local sorters = require("telescope.sorters")
local table_length = require("jr.utils").table_length
local nvim_lsp = require("lspconfig")
-- local nvim_tree_api = require("nvim-tree.api")
local jira = require("jr.custom.jira")
local curl = require("plenary.curl")

local project_map = {}

local function prime_project_map(opts)
	if table_length(project_map) > 0 then
		opts.on_exit(project_map)
		return
	end
	local cwd = path:new(vim.fn.getcwd())
	-- print(vim.inspect(scan.scan_dir_async))
	scan.scan_dir_async(cwd:normalize(), {
		search_pattern = "project.json",
		respect_gitignore = true,
		on_insert = vim.schedule_wrap(function(result)
			-- -- read the file in as JSON and get the name
			local json = vim.fn.json_decode(vim.fn.readfile(result))
			local project_name = json.name
			local source_root = json.sourceRoot
			local source_index = path:new(source_root):joinpath("index.ts"):absolute()
			local ts_config = path:new(result):parent():joinpath("tsconfig.json"):absolute()
			local root_dir = path:new(result):parent():absolute()
			project_map[project_name] = {
				source_index = source_index,
				project_name = project_name,
				ts_config = ts_config,
				root_dir = root_dir,
			}
		end),
		on_exit = function()
			opts.on_exit(project_map)
		end,
	})
end

local function create_popup_for_response(completion)
	-- creat a new buffer
	local bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_option(bufnr, "filetype", "markdown")
	local lines = vim.split(completion, "\n")

	-- assemble list of test results
	-- local lines = {}
	-- for _, result in ipairs(test_result) do
	-- 	local text = result.passed and "✅" or "❌"
	-- 	table.insert(lines, text .. " " .. result.name)
	-- end

	-- add a line of text
	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

	local width = 125
	local height = 25
	local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
	-- open a window in the center of the screen
	popup.create(bufnr, {
		title = "OpenAI Completion",
		line = math.floor(((vim.o.lines - height) / 2) - 1),
		col = math.floor((vim.o.columns - width) / 2),
		minwidth = width,
		minheight = height,
		borderchars = borderchars,
	})
	vim.opt_local.wrap = true
end

local function async_sleep(milliseconds, callback)
	vim.defer_fn(callback, milliseconds)
end
vim.api.nvim_create_user_command("RunThing", function(opts)
	local initial_modified = get_last_modified("/tmp/results.json")
	local timer = vim.loop.new_timer()
	timer:start(
		0,
		500,
		vim.schedule_wrap(function()
			local modified = get_last_modified("/tmp/results.json")
			if modified ~= initial_modified then
				print("FILE MODIFIED!!!")
				initial_modified = modified
			else
				print("file has not been modified")
			end
		end)
	)

	-- defer for 3 seconds then stop the timer

	async_sleep(30000, function()
		timer:stop()
	end)

	-- for i = 1, 100 do
	-- 	print(i)
	-- 	async_sleep(500, function()
	-- 		local modified = get_last_modified("/tmp/results.json")
	-- 		if modified ~= initial_modified then
	-- 			print("FILE MODIFIED!!!")
	-- 			initial_modified = modified
	-- 		else
	-- 			print("file has not been modified")
	-- 		end

	-- end

	-- local file_type = vim.bo.filetype
	-- local text = vim.fn.getline(vim.fn.getpos("")[2], vim.fn.getpos("'>")[2])
	-- local full_text = table.concat(text, "\n")
	-- -- write the file to /tmp/freeze
	-- local file = io.open("/tmp/freeze", "w")
	-- if file == nil then
	-- 	print("could not open file")
	-- 	return
	-- end
	-- file:write(full_text)
	-- file:close()
	--
	-- -- call the freeze command
	-- vim.fn.system("freeze /tmp/freeze -l" .. file_type .. " -o /tmp/freeze.png")
	--
	-- -- open the file in a new buffer
	-- vim.fn.system("open /tmp/freeze.png")
end, {

	range = true,
})

function get_last_modified(file_path)
	local attr = io.popen('stat -f "%m" "' .. file_path .. '"'):read("*a")
	if attr then
		return os.date("%Y-%m-%d %H:%M:%S", attr)
	else
		return nil, "File not found or error retrieving metadata"
	end
end
---------------------- Open AI thing

-- local line_number = vim.fn.line(".")
-- local file_name = vim.fn.expand("%:p")
--
-- local blame_commit = vim.fn.system(
-- 	"git blame --porcelain -L "
-- 		.. line_number
-- 		.. ","
-- 		.. line_number
-- 		.. " "
-- 		.. file_name
-- 		.. "| awk '{print $1; exit}'"
-- )
-- blame_commit = string.gsub(blame_commit, "%s+", "")
-- --
-- local jira_ticket = vim.fn.system("git log --format=%B -n 1 " .. blame_commit)
--
-- jira_ticket = jira_ticket:match("CAVO%-[0-9]+")
--
-- print(jira_ticket)
-- return blame_line:match("CAVO%-[0-9]+")
-- local OPENAI_API_KEY = vim.fn.getenv("OPENAI_API_KEY")
--
-- -- get text from selected range
-- local text = vim.fn.getline(vim.fn.getpos("'<")[2], vim.fn.getpos("'>")[2])
-- local file_type = vim.bo.filetype
--
-- local messages = {
-- 	{
-- 		role = "system",
-- 		content = "You are a helpful assistant that knows a lot about programming",
-- 	},
-- 	{
-- 		role = "user",
-- 		content = "explain the following code to me \n" .. "```" .. file_type .. "\n" .. text[1] .. "```",
-- 	},
-- }
-- local body = {
-- 	model = "gpt-3.5-turbo",
-- 	messages = messages,
-- 	temperature = 0.7,
-- }
-- --
-- --json encode messages
-- -- print(vim.fn.json_encode(body))
--
-- local response = curl.post("https://api.openai.com/v1/chat/completions", {
-- 	headers = {
-- 		["Authorization"] = "Bearer " .. OPENAI_API_KEY,
-- 		["Content-Type"] = "application/json",
-- 	},
-- 	body = vim.fn.json_encode(body),
-- })
--
-- -- local completion = "hello world"
-- -- get the body
-- local response_body = vim.fn.json_decode(response.body)
-- local completion = response_body.choices[1].message.content
-- --
-- -- local completion = "foo"
-- create_popup_for_response(completion)

-----------------

-- vim.api.nvim_create_user_command("RunThing", function()
-- 	-- Specify the directory for the LSP client
-- 	-- local directory = "/Users/justinrassier/dev/cavo/libs/shared/auth"
-- 	-- local directory = "/Users/justinrassier/dev/cavo/libs/shared/common/data-access"
--
-- 	-- Set up the LSP client for the specified directory using nvim-lspconfig
-- 	local server_name = "fake"
-- 	-- "/Users/justinrassier/.local/share/nvim/mason/bin/typescript-language-server",
-- 	local client_id = vim.lsp.start_client({
-- 		name = server_name,
-- 		cmd = {
-- 			"typescript-language-server",
-- 			"--stdio",
-- 		},
-- 		capabilities = vim.lsp.protocol.make_client_capabilities(),
-- 		-- filetypes = { "typescript" },
-- 		root_dir = "/Users/justinrassier/dev/cavo",
-- 	})
--
-- 	local lsp_client = vim.lsp.get_client_by_id(client_id)
-- 	vim.lsp.buf_attach_client(0, client_id)
--
-- 	local params = vim.lsp.util.make_position_params()
-- 	params.textDocument.uri =
-- 		vim.uri_from_fname("/Users/justinrassier/dev/cavo/libs/shared/common/data-access/src/lib/socket.service.ts")
-- 	params.position = { line = 20, character = 2 }
-- 	params.context = {
-- 		includeDeclaration = true,
-- 	}
-- 	-- Request lsp references for a specific token
-- 	lsp_client.request("textDocument/references", params, function(err, a, b)
-- 		if err then
-- 			print("Error requesting references: ", err)
-- 			return
-- 		end
-- 		print("references", vim.inspect(a))
-- 		-- Process the references response
-- 		-- ...
-- 	end)
-- end, {})

-- return M

--
