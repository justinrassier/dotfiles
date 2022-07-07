local vim = vim
local lsp = vim.lsp
local handlers = lsp.handlers
local lspconfig = require "lspconfig"
local util = lspconfig.util
local cmp = require'cmp'
local lspkind = require("lspkind")
local mapBuf = require("jr.utils").mapBuf
local autocmd = require("jr.utils").autocmd
local get_node_modules = require("jr.utils").get_node_modules
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- use GH CLI as a copletion source for git commit window
require("jr.lsp.cmp_gh_source")

-- help with function signatures
require "lsp_signature".setup()

-- custom text in auto complete dropdown
lspkind.init();



local luasnip = require("luasnip")
require("luasnip/loaders/from_vscode").lazy_load()

local down_func = cmp.mapping(function(fallback)
	if cmp.visible() then
		cmp.select_next_item()
	elseif luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	elseif has_words_before() then
		cmp.complete()
	else
		fallback()
	end
end, { "i", "s" })

local up_func = cmp.mapping(function(fallback)
	if cmp.visible() then
		cmp.select_prev_item()
	elseif luasnip.jumpable(-1) then
		luasnip.jump(-1)
	else
		fallback()
	end
end, { "i", "s" })


cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ["<Down>"] = down_func,
      ["<Up>"] = up_func,
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- For luasnip users.
    }, {
      { name = 'buffer' },
    }),
    formatting = {
      format = lspkind.cmp_format {
        with_text = true,
        menu = {
          buffer = "[buf]",
          nvim_lsp = "[LSP]",
          path = "[path]",
          luasnip = "[snip]",
          gh_issues = "[issues]",
        },
      },
    },
  })


-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline('/', {
--   sources = {
--     { name = 'buffer' }
--   }
-- })

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     { name = 'cmdline' }
--   })
-- })


local on_attach = function(client, bufnr)
  -- mapBuf(bufnr, "n", "<Leader>gdc", "<Cmd>lua vim.lsp.buf.declaration()<CR>")
  mapBuf(bufnr, "n", "<Leader>gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")

  -- gives me the type info of what I am hovering on
  mapBuf(bufnr, "n", "K", "<CMD>lua vim.lsp.buf.hover()<CR>")

  -- Perform code actions
  mapBuf(bufnr, "n", "<Leader>ca", "<cmd>CodeActionMenu<CR>")
  mapBuf(bufnr, "v", "<Leader>ca", "<cmd>CodeActionMenu<CR>")

  -- find references
  mapBuf(bufnr, "n", "<Leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>")

  -- diagnostic errors
  mapBuf(bufnr, "n", "<Leader>ne", "<cmd>lua vim.diagnostic.goto_next()<CR>")
  mapBuf(bufnr, "n", "<Leader>pe", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
  mapBuf(bufnr, "n", "<Leader>le", "<cmd>Telescope diagnostics<CR>")
  -- add errors to quickfix list
  -- mapBuf(bufnr, "n", "<Leader>qe", "<cmd>lua vim.diagnostic.set_qflist()<CR>")

  -- show diagnostic error for current position
  mapBuf(bufnr, "n", "<Leader>E", "<cmd>lua vim.diagnostic.open_float()<CR>")

  --markers in the gutter to highlight issues
  vim.fn.sign_define("DiagnosticSignError", {text = "•"})
  vim.fn.sign_define("DiagnosticSignWarn", {text = "•"})
  vim.fn.sign_define("DiagnosticSignInfo", {text = "•"})
  vim.fn.sign_define("DiagnosticSignHint", {text = "•"})



  --HACK:  disable rename on the angular LS because it causes conflicts with the TS language service during renames (remove after this is solved https://github.com/neovim/neovim/issues/16363)
  local rc = client.resolved_capabilities 
  if client.name == "angularls" then
    rc.rename = false
  end

  -- only attach renaming mapping if the client supports renaming
  if client.resolved_capabilities.rename then
    mapBuf(bufnr, "n", "<Leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
  end

  -- when you have your curosor over the top it highlights references in scope
  if client.resolved_capabilities.document_highlight then
    mapBuf(bufnr, "n", "<Leader>H", "<cmd>lua vim.lsp.buf.document_highlight()<CR>")
    vim.api.nvim_command("autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()")
    vim.api.nvim_command("autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()")
    vim.api.nvim_command("autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()")
  end

end


-- makes :OrganizeImports available as a command for TS
local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = {vim.api.nvim_buf_get_name(0)},
    title = ""
  }
  vim.lsp.buf.execute_command(params)
end
lspconfig.tsserver.setup {
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx"
  },
  -- cmd = {"typescript-language-server", "--stdio", "--log-level=4", "--tsserver-log-file=ts-logs.txt"},
  on_attach = on_attach,
  capabilities = capabilities,
  commands = {
    OrganizeImports = {
      organize_imports,
      description = "Organize Imports"
    }
  },
  root_dir = util.root_pattern("package.json", ".git")

}




local default_node_modules = get_node_modules(vim.fn.getcwd())
-- local default_node_modules = '/Users/justinrassier/dev/cavo'
local ngls_cmd = {
  "ngserver",
  "--stdio",
  "--tsProbeLocations",
  default_node_modules,
  "--ngProbeLocations",
  default_node_modules
}
-- local cmd = {"ngserver", "--stdio", "--tsProbeLocations", project_library_path , "--ngProbeLocations", project_library_path}


lspconfig.angularls.setup {
  cmd = ngls_cmd,
  capabilities = capabilities,
  on_attach = on_attach,
  on_new_config = function(new_config)
    new_config.cmd = ngls_cmd
  end
}

lspconfig.tailwindcss.setup {
  on_attach = on_attach,
  capabilities = capabilities
}

lspconfig.eslint.setup{
  on_attach = on_attach,
  capabilities = capabilities
}

lspconfig.jsonls.setup {
  cmd = {"vscode-json-language-server", "--stdio"},
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"json", "jsonc"},
  settings = {
    json = {
      -- Schemas https://www.schemastore.org
      schemas = {
        {
          fileMatch = {"package.json"},
          url = "https://json.schemastore.org/package.json"
        },
        {
          fileMatch = {"tsconfig*.json"},
          url = "https://json.schemastore.org/tsconfig.json"
        },
        {
          fileMatch = {
            ".prettierrc",
            ".prettierrc.json",
            "prettier.config.json"
          },
          url = "https://json.schemastore.org/prettierrc.json"
        },
        {
          fileMatch = {".eslintrc", ".eslintrc.json"},
          url = "https://json.schemastore.org/eslintrc.json"
        },
        {
          fileMatch = {".babelrc", ".babelrc.json", "babel.config.json"},
          url = "https://json.schemastore.org/babelrc.json"
        },
        {
          fileMatch = {"now.json", "vercel.json"},
          url = "https://json.schemastore.org/now.json"
        },
        {
          fileMatch = {
            ".stylelintrc",
            ".stylelintrc.json",
            "stylelint.config.json"
          },
          url = "http://json.schemastore.org/stylelintrc.json"
        },
      }
    }
  }
}

lspconfig.cssls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}

lspconfig.svelte.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}


lspconfig.rust_analyzer.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}


lspconfig.gopls.setup{
  on_attach = on_attach,
  capabilities = capabilities
}

