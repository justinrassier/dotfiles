" call plug#begin('~/.vim/plugged')
call plug#begin()
" Lsp stuff
Plug 'neovim/nvim-lspconfig'

" Fuzzy: finder
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
Plug 'nvim-treesitter/playground'
Plug 'nvim-telescope/telescope-github.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-telescope/telescope-node-modules.nvim'
Plug 'nvim-telescope/telescope-live-grep-args.nvim'

" Prettier formatting
Plug 'sbdchd/neoformat' "keep neoformat for in-buffer formatting only
Plug 'mhartington/formatter.nvim'

Plug 'windwp/nvim-ts-autotag'

" Surround 
Plug 'tpope/vim-surround'

" file explorer
Plug 'kyazdani42/nvim-tree.lua'

" DIY auto complete stuff using nvim-cmp
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
"
Plug 'onsails/lspkind-nvim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'weilbith/nvim-code-action-menu'

"Snippets. vnsip lets you use vs code ones!
Plug 'johnpapa/vscode-angular-snippets'
Plug 'andys8/vscode-jest-snippets'

" TODO plugin
Plug 'folke/todo-comments.nvim'

" Highlight on yank
Plug 'machakann/vim-highlightedyank'

" Theme and editor basics
Plug 'gruvbox-community/gruvbox'
Plug 'mhartington/oceanic-next'
Plug 'folke/tokyonight.nvim'
Plug 'editorconfig/editorconfig-vim'
Plug 'kyazdani42/nvim-web-devicons'


" JS Doc
Plug 'heavenshell/vim-jsdoc', {
  \ 'for': ['javascript', 'typescript'],
  \ 'do': 'make install'
\}

" Block commenting
Plug 'numToStr/Comment.nvim'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'

" Git
Plug 'lewis6991/gitsigns.nvim'
Plug 'kdheepak/lazygit.nvim'
Plug 'sindrets/diffview.nvim'


" Bufferline and statuslin
Plug 'nvim-lualine/lualine.nvim'
Plug 'akinsho/bufferline.nvim'

" Markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

" Plug 'jiangmiao/auto-pairs'

Plug 'ThePrimeagen/harpoon'

" Experimental
Plug 'vim-test/vim-test'
Plug 'pwntester/octo.nvim'
Plug 'vimwiki/vimwiki'
Plug 'theprimeagen/jvim.nvim'
Plug 'SmiteshP/nvim-gps'
Plug 'github/copilot.vim'


call plug#end()

lua require("jr.options")
lua require("jr.colors")
lua require("jr.mappings")
lua require("jr.autocmds")
lua require("jr.treesitter")
lua require("jr.lsp")
lua require("jr.telescope")
lua require ("jr.comment")
lua require ("jr.formatting")
lua require ("jr.statusline")
lua require('jr.gitsigns')
lua require('jr.nvim-tree')
lua require('jr.harpoon')

" stuff that doesn't need its own config file yet
lua require("todo-comments").setup {}
lua require('octo').setup()
lua require'nvim-web-devicons'.setup()
lua require('nvim-ts-autotag').setup()


" au FileType markdown let b:presenting_slide_separator = '---'



" function! Scratch()
"     "split
"     noswapfile hide enew
"     setlocal buftype=nofile
"     setlocal bufhidden=hide
"     setlocal filetype=markdown
"     setlocal spell
"     set wrap linebreak
"     "setlocal nobuflisted
"     "lcd ~
"     file scratch
" endfunction
" function! JsonScratch()
"     "split
"     noswapfile hide enew
"     setlocal buftype=nofile
"     setlocal bufhidden=hide
"     setlocal filetype=json
"     file json-scratch
" endfunction

"lua require("treesitter")
