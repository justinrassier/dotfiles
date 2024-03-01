require("packer").startup(function(use)
	use("~/dev/jesting.nvim")
	-- use({ "justinrassier/jesting.nvim", branch = "test" })
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
		-- "jose-elias-alvarez/null-ls.nvim",
		"ray-x/lsp_signature.nvim",
	})

	-- Telescope
	use("nvim-telescope/telescope.nvim")
	use("nvim-treesitter/playground")
	use("nvim-telescope/telescope-github.nvim")
	use("nvim-telescope/telescope-fzy-native.nvim")
	use("nvim-telescope/telescope-node-modules.nvim")
	use("nvim-telescope/telescope-live-grep-args.nvim")

	use("folke/todo-comments.nvim")
	use("machakann/vim-highlightedyank")
	use("windwp/nvim-ts-autotag")

	-- Block commenting
	use("numToStr/Comment.nvim")
	use("JoosepAlviste/nvim-ts-context-commentstring")

	-- color schemes
	use({ "catppuccin/nvim", as = "catppuccin" })
	use("rebelot/kanagawa.nvim")

	-- git
	use("lewis6991/gitsigns.nvim")
	use("kdheepak/lazygit.nvim")

	use("nvim-lualine/lualine.nvim")
	use("kyazdani42/nvim-tree.lua")
	use("ThePrimeagen/harpoon")
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
	use("mbbill/undotree")
	use("christoomey/vim-tmux-navigator")
	use({ "sindrets/diffview.nvim", requires = "nvim-lua/plenary.nvim" })

	use({ "justinrassier/nvim-treesitter-angular", branch = "fixes" })

	use({ "mhartington/formatter.nvim" })

	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	})
end)

require("jr.options")
require("jr.colors")
require("jr.mappings")
require("jr.autocmds")
require("jr.custom.commands")

----stuff that doesn't need its own config file yet

require("todo-comments").setup({})
require("nvim-web-devicons").setup()
require("nvim-ts-autotag").setup()

-- do this last so colors actually work
-- require("jr.colors.illuminate")

-- TODO: put this somewhere better
vim.cmd("JRStartCheckingPRs")
vim.cmd("JRTimeTrackingStart")
-- vim.cmd("Copilot disable")
--
--
vim.api.nvim_exec(
	[[
    autocmd BufNewFile,BufRead *.ng set filetype=ng
]],
	false
)
