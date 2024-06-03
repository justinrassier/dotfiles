return {
	"stevearc/conform.nvim",
	event = "BufRead",
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			-- Disable with a global or buffer-local variable
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return { timeout_ms = 2000, lsp_fallback = true }
		end,
		formatters_by_ft = {
			sql = { "sql_formatter" },
			lua = { "stylua" },
			-- Conform can also run multiple formatters sequentially
			-- python = { "isort", "black" },
			--
			rust = { "rust-analyzer" },
			-- You can use a sub-list to tell conform to run *until* a formatter
			-- is found.
			javascript = { { "prettierd", "prettier" } },
			typescript = { { "prettierd", "prettier" } },
			css = { "prettierd", "prettier" },
			scss = { "prettierd", "prettier" },
			html = { { "prettierd", "prettier" } },
			json = { { "prettierd", "prettier" } },
			markdown = { "prettierd" },
		},
	},
}
