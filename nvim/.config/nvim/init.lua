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
		"ray-x/lsp_signature.nvim",
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

	use({
		"heavenshell/vim-jsdoc",
		run = "make install",
		setup = function()
			vim.g.jsdoc_lehre_path = "/Users/justinrassier/.nvm/versions/node/v18.13.0/bin/lehre"
			vim.g.jsdoc_formatter = "tsdoc"
		end,
	})

	-- color schemes
	use("folke/tokyonight.nvim")
	-- use("rose-pine/neovim")
	use({ "catppuccin/nvim", as = "catppuccin" })
	use("rebelot/kanagawa.nvim")

	-- git
	use("lewis6991/gitsigns.nvim")
	use("kdheepak/lazygit.nvim")

	-- tree/navigation/bufferline
	use("nvim-lualine/lualine.nvim")
	use("akinsho/bufferline.nvim")
	use("kyazdani42/nvim-tree.lua")
	use("ThePrimeagen/harpoon")
	use("SmiteshP/nvim-gps")
	use({
		"github/copilot.vim",
		branch = "release",
		-- config = function()
		-- 	local sysname = vim.loop.os_uname().sysname
		-- 	if sysname == "Darwin" then
		-- 		vim.g.copilot_node_command = "/Users/justinrassier/.nvm/versions/node/v18.12.1/bin/node"
		-- 	end
		-- end,
	})
	-- use("stevearc/aerial.nvim")
	use("mbbill/undotree")

	use("christoomey/vim-tmux-navigator")

	use("RRethy/vim-illuminate")

	use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })

	-- use("nvim-treesitter/nvim-treesitter-angular")
	use({ "justinrassier/nvim-treesitter-angular", branch = "fixes" })
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

-- do this last so colors actually work
require("jr.colors.illuminate")

-- TODO: put this somewhere better
vim.cmd("JRStartCheckingPRs")
vim.cmd("JRStartTimeTracking")
