" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Lsp stuff
Plug 'neovim/nvim-lspconfig'

" Fuzzy finder
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 

" Prettier formatting
Plug 'sbdchd/neoformat'

" emmet
Plug 'mattn/emmet-vim'

" file explorer
Plug 'preservim/nerdtree'

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

"Snippets. vnsip lets you use vs code ones!
Plug 'johnpapa/vscode-angular-snippets'
Plug 'andys8/vscode-jest-snippets'

" Highlight on yank
Plug 'machakann/vim-highlightedyank'

" Theme from mike hartington
Plug 'gruvbox-community/gruvbox'

" JS Doc
Plug 'heavenshell/vim-jsdoc', {
  \ 'for': ['javascript', 'typescript'],
  \ 'do': 'make install'
\}

" Block commenting
Plug 'terrortylor/nvim-comment'


" Git
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'

" Initialize plugin system
call plug#end()

set completeopt=menu,menuone,noselect
lua require("lsp-config")
lua require('nvim_comment').setup()

let mapleader = " " 
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab


" time for event like CursoHold (hover) to make docs appear quick
set updatetime=500
set redrawtime=500


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

" set working directory relative to open buffer
" set autochdir

" visual paste but don't replace buffer
vnoremap <leader>p "_dp

" hybrid line numbers
set number
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END


" Telescope
nnoremap <c-p> :lua require'telescope.builtin'.git_files{}<CR>

" Standard Vim Keymappings
nnoremap <silent> <Leader>+ :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "vertical resize  " . (winwidth(0) * 2/3)<CR>
" move line up/down
nnoremap <leader>k :m .-2<CR>==
nnoremap <leader>j :m .+1<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap K :m '<-2<CR>gv=gv
vnoremap J :m '>+1<CR>gv=gv

" remap capital Y to highlight to end of line
nnoremap Y y$

" quickfix navigation
nnoremap <leader>cn :cn<CR>
nnoremap <leader>cp :cp<CR>
nnoremap <leader>co :copen<CR>
nnoremap <leader>cl :cclose<CR>
nnoremap <leader>cl :cclose<CR>


" split navigation
set splitbelow
set splitright
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l


" buffer navigation
nnoremap <C-j> :bnext<CR>
nnoremap <C-k> :bprev<CR>

" Runm prettier on save
augroup fmt
  autocmd!
  autocmd BufWritePre *.{js,ts,html} undojoin | Neoformat
augroup END


" NERDTree
let NERDTreeWinSize=45
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
" remap open split
let g:NERDTreeMapOpenVSplit = 'v'


"vim-vsnip 
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'


" Add undo breakpoints to make undo less aggressive
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ? ?<c-g>u
inoremap ! !<c-g>u
inoremap { {<c-g>u
inoremap } }<c-g>u
inoremap ( (<c-g>u
inoremap ) )<c-g>u


" Highlight  on yank plugin
let g:highlightedyank_highlight_duration = 250


" Theme (Move to new file)
if (has("termguicolors"))
 set termguicolors
endif

" Theme
syntax enable

"colorscheme OceanicNext
colorscheme gruvbox


let g:theprimeagen_colorscheme = "gruvbox"
fun! ColorMyPencils()
    let g:gruvbox_contrast_dark = 'hard'
    if exists('+termguicolors')
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif
    let g:gruvbox_invert_selection='0'

    set background=dark
    if has('nvim')
        call luaeval('vim.cmd("colorscheme " .. _A[1])', [g:theprimeagen_colorscheme])
    else
        " TODO: What the way to use g:theprimeagen_colorscheme
        colorscheme gruvbox
    endif

    highlight ColorColumn ctermbg=0 guibg=grey
    hi SignColumn guibg=none
    hi CursorLineNR guibg=None
    highlight Normal guibg=none
    " highlight LineNr guifg=#ff8659
    " highlight LineNr guifg=#aed75f
    highlight LineNr guifg=#5eacd3
    highlight netrwDir guifg=#5eacd3
    highlight qfFileName guifg=#aed75f
    hi TelescopeBorder guifg=#5eacd
endfun
call ColorMyPencils()



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



"lua require("treesitter")
