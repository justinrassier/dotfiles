require("mason").setup()
local mason_lsp = require("mason-lspconfig")
local mapBuf = require("jr.utils").mapBuf
local nvim_lsp = require("lspconfig")
require("lsp_signature").setup()

require("luasnip/loaders/from_vscode").lazy_load()
-- Set up nvim-cmp.
local cmp = require("cmp")
cmp.setup({
	enabled = function()
		if
			require("cmp.config.context").in_treesitter_capture("comment") == true
			or require("cmp.config.context").in_syntax_group("Comment")
			or vim.api.nvim_buf_get_option(0, "filetype") == "TelescopePrompt"
		then
			return false
		else
			return true
		end
	end,
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" }, -- For luasnip users.
	}, {
		{ name = "buffer" },
	}),
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(":", {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = "path" },
--   }, {
--     { name = "cmdline" },
--   }),
-- })
--
-- Set up lspconfig.
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local function on_attach(client, bufnr)
	-- mapBuf(bufnr, "n", "<Leader>gdc", "<Cmd>lua vim.lsp.buf.declaration()<CR>")
	mapBuf(bufnr, "n", "<Leader>gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")
	mapBuf(bufnr, "n", "<Leader>gt", "<Cmd>lua vim.lsp.buf.type_definition()<CR>")

	-- gives me the type info of what I am hovering on
	mapBuf(bufnr, "n", "K", "<CMD>lua vim.lsp.buf.hover()<CR>")

	-- Perform code actions
	mapBuf(bufnr, "n", "<Leader>ca", "<cmd>CodeActionMenu<CR>")
	mapBuf(bufnr, "v", "<Leader>ca", "<cmd>CodeActionMenu<CR>")

	-- find references
	mapBuf(bufnr, "n", "<Leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>")
	mapBuf(bufnr, "n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")

	-- diagnostic errors
	mapBuf(bufnr, "n", "<Leader>ne", "<cmd>lua vim.diagnostic.goto_next()<CR>")
	mapBuf(bufnr, "n", "<Leader>pe", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
	mapBuf(bufnr, "n", "<Leader>le", "<cmd>Telescope diagnostics<CR>")

	-- show diagnostic error for current position
	mapBuf(bufnr, "n", "<Leader>E", "<cmd>lua vim.diagnostic.open_float()<CR>")

	--markers in the gutter to highlight issues
	vim.fn.sign_define("DiagnosticSignError", { text = "•" })
	vim.fn.sign_define("DiagnosticSignWarn", { text = "•" })
	vim.fn.sign_define("DiagnosticSignInfo", { text = "•" })
	vim.fn.sign_define("DiagnosticSignHint", { text = "•" })

	-- disable augo formatting from the language server to not conflict with
	local language_servers = { "tsserver", "lua_ls", "gopls", "html", "rust_analyzer", "jsonls", "vtsls" }
	for _, value in ipairs(language_servers) do
		if value == client.name then
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end
	end

	-- HACK: disable tsserver on deno projects
	if require("lspconfig").util.root_pattern("deno.json", "deno.jsonc")(vim.fn.getcwd()) then
		if client.name == "tsserver" then
			client.stop()
			return
		end
	end
end

local function organize_imports()
	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
		title = "",
	}
	vim.lsp.buf.execute_command(params)
end

mason_lsp.setup({
	ensure_installed = {
		"lua_ls",
		"rust_analyzer",
		"angularls",
		"tailwindcss",
	},
})

mason_lsp.setup_handlers({
	function(server_name)
		if server_name == "volar" then
			nvim_lsp.volar.setup({
				filetypes = { "ng", "typescript", "javascript", "javascriptreact", "typescriptreact", "vue", "json" },
				root_dir = nvim_lsp.util.root_pattern("package.json"),
				capabilities = capabilities,
			})
		end

		-- only add deno if there is a deno.json file at the root
		if server_name == "denols" then
			nvim_lsp.denols.setup({
				root_dir = nvim_lsp.util.root_pattern("deno.json"),
				on_attach = on_attach,
				capabilities = capabilities,
			})
		elseif server_name == "tsserver" or server_name == "vtsls" then
			if server_name == "tsserver" then
				nvim_lsp.tsserver.setup({
					on_attach = on_attach,
					capabilities = capabilities,
					root_dir = nvim_lsp.util.root_pattern("package.json", "tsconfig.base.json", "jsconfig.json"),
					commands = {
						OrganizeImports = {
							organize_imports,
							description = "Organize Imports",
						},
					},
				})
			else
				nvim_lsp.vtsls.setup({
					on_attach = on_attach,
					capabilities = capabilities,
					root_dir = nvim_lsp.util.root_pattern("package.json", "tsconfig.base.json", "jsconfig.json"),
					commands = {
						OrganizeImports = {
							organize_imports,
							description = "Organize Imports",
						},
					},
				})
			end
		elseif server_name == "eslint" then
			nvim_lsp.eslint.setup({
				root_dir = nvim_lsp.util.root_pattern("package.json"),
				on_attach = on_attach,
				capabilities = capabilities,
			})
		elseif server_name == "angularls" then
			nvim_lsp.angularls.setup({
				root_dir = nvim_lsp.util.root_pattern("package.json"),
				on_attach = on_attach,
				capabilities = capabilities,
			})
		elseif server_name == "lua_ls" then
			nvim_lsp.lua_ls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					Lua = {
						runtime = {
							version = "LuaJIT",
							path = vim.split(package.path, ";"),
						},
						diagnostics = {
							globals = { "vim", "use", "describe", "it", "before_each", "after_each" },
						},
						workspace = {
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
							},
						},
					},
				},
			})
		else
			nvim_lsp[server_name].setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end
	end,
})
