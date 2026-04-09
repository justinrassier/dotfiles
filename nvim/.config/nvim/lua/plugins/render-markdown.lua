return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown", "mdx" },
	dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
	opts = {
		completions = { lsp = { enabled = true } },
	},
}
