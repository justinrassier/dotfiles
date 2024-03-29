return {
	"stevearc/conform.nvim",
	event = "BufRead",
	opts = {
		notify_on_error = false,
		format_on_save = {
			timeout_ms = 2000,
			lsp_fallback = true,
		},
		formatters_by_ft = {
			lua = { "stylua" },
			-- Conform can also run multiple formatters sequentially
			-- python = { "isort", "black" },
			--
			rust = { "rust-analyzer" },
			-- You can use a sub-list to tell conform to run *until* a formatter
			-- is found.
			javascript = { { "prettierd", "prettier" } },
			typescript = { { "prettierd", "prettier" } },
			html = { { "prettierd", "prettier" } },
			json = { { "prettierd", "prettier" } },
			markdown = { "prettierd" },
		},
	},
}
