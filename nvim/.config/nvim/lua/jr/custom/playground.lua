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
local nvim_tree_api = require("nvim-tree.api")
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

local bare_prompt = ""
function do_thing()
	print("hello")
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

vim.api.nvim_create_user_command("RunThing", function(opts)
	local OPENAI_API_KEY = vim.fn.getenv("OPENAI_API_KEY")

	-- get text from selected range
	local text = vim.fn.getline(vim.fn.getpos("'<")[2], vim.fn.getpos("'>")[2])
	local file_type = vim.bo.filetype

	local messages = {
		{
			role = "system",
			content = "You are a helpful assistant that knows a lot about programming",
		},
		{
			role = "user",
			content = "explain the following code to me \n" .. "```" .. file_type .. "\n" .. text[1] .. "```",
		},
	}
	local body = {
		model = "gpt-3.5-turbo",
		messages = messages,
		temperature = 0.7,
	}
	--
	--json encode messages
	-- print(vim.fn.json_encode(body))

	local response = curl.post("https://api.openai.com/v1/chat/completions", {
		headers = {
			["Authorization"] = "Bearer " .. OPENAI_API_KEY,
			["Content-Type"] = "application/json",
		},
		body = vim.fn.json_encode(body),
	})

	-- local completion = "hello world"
	-- get the body
	local response_body = vim.fn.json_decode(response.body)
	local completion = response_body.choices[1].message.content
	--
	-- local completion = "foo"
	create_popup_for_response(completion)
end, {

	range = true,
})

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
