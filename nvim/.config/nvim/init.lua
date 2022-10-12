
require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Simple plugins can be specified as strings
 -- use '9mm/vim-closer'
  use("nvim-lua/plenary.nvim")
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  use("neovim/nvim-lspconfig")
  use ("kyazdani42/nvim-web-devicons")

  use ("kyazdani42/nvim-tree.lua")

  -- Telescope
  use("nvim-telescope/telescope.nvim")
  use("nvim-treesitter/playground")
  use("nvim-telescope/telescope-github.nvim")
  use("nvim-telescope/telescope-fzy-native.nvim")
  use("nvim-telescope/telescope-node-modules.nvim")
  use("nvim-telescope/telescope-live-grep-args.nvim")

  -- nvim-cmp stuff
  use ("hrsh7th/nvim-cmp")
  use ("hrsh7th/cmp-nvim-lsp")
  use ("hrsh7th/cmp-buffer")
  use ("hrsh7th/cmp-path")
  use ("hrsh7th/cmp-cmdline")
  use ("L3MON4D3/LuaSnip")
  use ("saadparwaiz1/cmp_luasnip")
  use ("onsails/lspkind-nvim")
  use ("ray-x/lsp_signature.nvim")
  use ("weilbith/nvim-code-action-menu")

  --Snippets. vnsip lets you use vs code ones!
  use ("johnpapa/vscode-angular-snippets")
  use ("andys8/vscode-jest-snippets")


  use ("folke/todo-comments.nvim")
  use ("machakann/vim-highlightedyank")

  use "folke/tokyonight.nvim"
  use("mhartington/formatter.nvim")
  use("windwp/nvim-ts-autotag")

  -- Block commenting
  use ("numToStr/Comment.nvim")
  use ("JoosepAlviste/nvim-ts-context-commentstring")
  use ("lewis6991/gitsigns.nvim")
  use ("kdheepak/lazygit.nvim")
  use ("sindrets/diffview.nvim")

  --Bufferline and statusline
  use ("nvim-lualine/lualine.nvim")
  use ("akinsho/bufferline.nvim")

  -- Markdown
  --use ("iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  ")
  use({ "iamcco/markdown-preview.nvim", 
    run = "cd app && npm install",
    setup = function() vim.g.mkdp_filetypes = { "markdown" } end,
    ft = { "markdown" }
  })
  use ("ellisonleao/glow.nvim")


  use ("ThePrimeagen/harpoon")
  use ("jose-elias-alvarez/null-ls.nvim")
  use ("SmiteshP/nvim-gps")
  use ("github/copilot.vim")

end)

require("jr.options")
require("jr.lsp")
require("jr.lsp.null-ls")
require("jr.colors")
require("jr.mappings")
require("jr.autocmds")
require("jr.treesitter")
require("jr.telescope")
require ("jr.comment")
require ("jr.formatting")
require ("jr.statusline")
require('jr.gitsigns')
require('jr.nvim-tree')
require('jr.harpoon')
--
----stuf that doesn't need its own config file yet
require("todo-comments").setup {}
require'nvim-web-devicons'.setup()
require('nvim-ts-autotag').setup()
require('glow').setup()
