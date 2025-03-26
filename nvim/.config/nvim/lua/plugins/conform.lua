-- return {
-- 	"stevearc/conform.nvim",
-- 	event = "BufRead",
-- 	opts = {
-- 		notify_on_error = false,
-- 		format_on_save = function(bufnr)
-- 			-- Disable with a global or buffer-local variable
-- 			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
-- 				return
-- 			end
-- 			return { timeout_ms = 2000, lsp_fallback = true }
-- 		end,
-- 		formatters_by_ft = {
-- 			sql = { "sql_formatter" },
-- 			lua = { "stylua" },
-- 			-- Conform can also run multiple formatters sequentially
-- 			-- python = { "isort", "black" },
-- 			--
-- 			rust = { "rust-analyzer" },
-- 			-- You can use a sub-list to tell conform to run *until* a formatter
-- 			-- is found.
-- 			javascript = { { "prettierd", "prettier" } },
-- 			typescript = { { "prettierd", "prettier" } },
-- 			css = { "prettierd", "prettier" },
-- 			scss = { "prettierd", "prettier" },
-- 			html = { { "prettierd", "prettier" } },
-- 			json = { { "prettierd", "prettier" } },
-- 			markdown = { "prettierd" },
-- 		},
-- 	},
-- }
return { -- Autoformat
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			-- Disable "format_on_save lsp_fallback" for languages that don't
			-- have a well standardized coding style. You can add additional
			-- languages here or re-enable it for the disabled ones.
			local disable_filetypes = { c = true, cpp = true }
			local lsp_format_opt
			if disable_filetypes[vim.bo[bufnr].filetype] then
				lsp_format_opt = "never"
			else
				lsp_format_opt = "fallback"
			end
			return {
				timeout_ms = 1000,
				lsp_format = lsp_format_opt,
			}
		end,
		formatters_by_ft = {
			sql = { "sql_formatter" },
			lua = { "stylua" },
			-- Conform can also run multiple formatters sequentially
			-- python = { "isort", "black" },
			--
			rust = { "rust-analyzer" },
			html = { "prettier" },
			-- You can use a sub-list to tell conform to run *until* a formatter
			-- is found.
			javascript = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			css = { "prettier" },
			-- scss = { "prettierd", "prettier" },
			json = { "prettier" },
			markdown = { "prettier" },
			mdx = { "prettier" },
		},
	},
}
