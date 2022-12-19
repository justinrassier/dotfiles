local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.prettierd,
		-- null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.gofmt,
		null_ls.builtins.formatting.goimports,
		null_ls.builtins.formatting.rustfmt,
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.stylelint,

		-- null_ls.builtins.diagnostics.cspell,
		null_ls.builtins.diagnostics.eslint,
		null_ls.builtins.diagnostics.stylelint,

		null_ls.builtins.code_actions.eslint,
		null_ls.builtins.code_actions.gitsigns,

		null_ls.builtins.code_actions.cspell.with({
			filetypes = { "markdown", "tex", "text" },
		}),
		null_ls.builtins.diagnostics.cspell.with({
			filetypes = { "markdown", "tex", "text" },
		}),
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ async = false })
				end,
			})
		end
	end,
})
