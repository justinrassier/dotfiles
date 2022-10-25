local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		null_ls.builtins.code_actions.cspell.with({
			filetypes = { "markdown", "tex", "text" },
		}),
		null_ls.builtins.diagnostics.cspell.with({
			filetypes = { "markdown", "tex", "text" },
		}),
	},
})
