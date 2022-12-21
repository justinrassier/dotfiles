require("packer").startup(function(use)
	use("~/dev/jesting.nvim")
	-- Packer can manage itself
	use("wbthomason/packer.nvim")
	use("nvim-lua/plenary.nvim")
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

	use("kyazdani42/nvim-web-devicons")

	-- lsp stuff
	use({
		"neovim/nvim-lspconfig",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",
		-- Snippets
		"L3MON4D3/LuaSnip",
		"rafamadriz/friendly-snippets",
		-- code actions
		"weilbith/nvim-code-action-menu",
		"jose-elias-alvarez/null-ls.nvim",
	})

	-- Telescope
	use("nvim-telescope/telescope.nvim")
	use("nvim-treesitter/playground")
	use("nvim-telescope/telescope-github.nvim")
	use("nvim-telescope/telescope-fzy-native.nvim")
	use("nvim-telescope/telescope-node-modules.nvim")
	use("nvim-telescope/telescope-live-grep-args.nvim")

	--Snippets. vnsip lets you use vs code ones!
	use("johnpapa/vscode-angular-snippets")
	use("andys8/vscode-jest-snippets")

	use("folke/todo-comments.nvim")
	use("machakann/vim-highlightedyank")
	use("windwp/nvim-ts-autotag")

	-- Block commenting
	use("numToStr/Comment.nvim")
	use("JoosepAlviste/nvim-ts-context-commentstring")

	-- Markdown
	--use ("iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  ")
	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	})

	-- color schemes
	use("folke/tokyonight.nvim")
	use("rose-pine/neovim")

	-- git
	use("lewis6991/gitsigns.nvim")
	use("kdheepak/lazygit.nvim")
	use("sindrets/diffview.nvim")

	-- tree/navigation/bufferline
	use("nvim-lualine/lualine.nvim")
	use("akinsho/bufferline.nvim")
	use("kyazdani42/nvim-tree.lua")
	use("ThePrimeagen/harpoon")
	use("SmiteshP/nvim-gps")
	use("github/copilot.vim")
	use("stevearc/aerial.nvim")
	use("mbbill/undotree")
end)

require("jr.options")
-- require("jr.lsp")
require("jr.colors")
require("jr.mappings")
require("jr.autocmds")
require("jr.custom.commands")

----stuff that doesn't need its own config file yet
require("todo-comments").setup({})
require("nvim-web-devicons").setup()
require("nvim-ts-autotag").setup()
