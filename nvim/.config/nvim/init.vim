call plug#begin('~/.vim/plugged')
" Lsp stuff
Plug 'neovim/nvim-lspconfig'

" Fuzzy: finder
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
Plug 'nvim-telescope/telescope-github.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'
Plug 'nvim-telescope/telescope-node-modules.nvim'

" Prettier formatting
" Plug 'sbdchd/neoformat'
Plug 'mhartington/formatter.nvim'

" emmet
Plug 'mattn/emmet-vim'

" Surround 
Plug 'tpope/vim-surround'

" file explorer
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
  

" DIY auto complete stuff using nvim-cmp
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
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

" Theme
Plug 'gruvbox-community/gruvbox'
Plug 'mhartington/oceanic-next'

" JS Doc
Plug 'heavenshell/vim-jsdoc', {
  \ 'for': ['javascript', 'typescript'],
  \ 'do': 'make install'
\}

" Block commenting
Plug 'numToStr/Comment.nvim'
" Plug 'terrortylor/nvim-comment'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'

" Git
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
" Plug 'airblade/vim-gitgutter'
Plug 'lewis6991/gitsigns.nvim'

Plug 'kyazdani42/nvim-web-devicons'

" package.json info
Plug 'meain/vim-package-info', { 'do': 'npm install' }

" Experimental
Plug 'pwntester/octo.nvim'
Plug 'folke/zen-mode.nvim'
Plug 'folke/twilight.nvim'


call plug#end()

set completeopt=menu,menuone,noselect
let mapleader = " " 

lua require("jr.mappings")
lua require("jr.treesitter")
lua require("jr.lsp")
lua require("jr.telescope")
lua require ("jr.comment")
lua require ("jr.formatting")

lua require("todo-comments").setup {}
lua require('octo').setup()
lua require("zen-mode").setup()
lua require("twilight").setup()
lua require('gitsigns').setup()


set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

set foldmethod=syntax
set foldlevelstart=1

" time for event like CursoHold (hover) to make docs appear quick
" set updatetime=500
" set redrawtime=500


" Highlight search as you type
set incsearch
" disable highlighting after searching
set nohlsearch

" keep buffers open in the background
set hidden

" don't wrap text
set nowrap

" history stuff
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile

" start scrolling 8 lines from the bottom instead of waiting until cursor is all the way down
set scrolloff=8

set signcolumn=yes

" hybrid line numbers
set number
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END


" split navigation default locations
set splitbelow
set splitright


" NERDTree
let NERDTreeWinSize=45
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
let g:NERDTreeMapOpenVSplit = '<c-v>'


"vim-vsnip 
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" Highlight  on yank plugin
let g:highlightedyank_highlight_duration = 250


" Theme
if (has("termguicolors"))
 set termguicolors
endif

syntax enable

" colorscheme gruvbox
colorscheme OceanicNext
let g:airline_theme='oceanicnext'


" Emmet customization -------------------------------------------------------{{{

" Remaps to be like Emmet in a normal editor with tab expand
  function! s:expand_html_tab()
" try to determine if we're within quotes or tags.
" if so, assume we're in an emmet fill area.
   let line = getline('.')
   if col('.') < len(line)
     let line = matchstr(line, '[">][^<"]*\%'.col('.').'c[^>"]*[<"]')
     if len(line) >= 2
        return "\<C-n>"
     endif
   endif
" expand anything emmet thinks is expandable.
  if emmet#isExpandable()
    return emmet#expandAbbrIntelligent("\<tab>")
    " return "\<C-y>,"
  endif
" return a regular tab character
  return "\<tab>"
  endfunction
  " let g:user_emmet_expandabbr_key='<Tab>'
  " imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

  autocmd FileType html,css,scss,typescriptreact,vue,javascript,markdown.mdx imap <silent><buffer><expr><tab> <sid>expand_html_tab()
  let g:user_emmet_mode='a'
  let g:user_emmet_complete_tag = 0
  let g:user_emmet_install_global = 0
  autocmd FileType html,css,scss,typescriptreact,vue,javascript,markdown.mdx EmmetInstall

"}}}

vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

"lua require("treesitter")
