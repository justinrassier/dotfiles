" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Lsp stuff
Plug 'neovim/nvim-lspconfig'

" Fuzzy finder
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

" Prettier formatting
Plug 'sbdchd/neoformat'

" emmet
Plug 'mattn/emmet-vim'

" file explorer
Plug 'preservim/nerdtree'

" all the fancy auto complete stuff out of the box
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Highlight on yank
Plug 'machakann/vim-highlightedyank'

" Theme from mike hartington
Plug 'mhartington/oceanic-next'
Plug 'gruvbox-community/gruvbox'

" JS Doc
Plug 'heavenshell/vim-jsdoc', {
  \ 'for': ['javascript', 'typescript'],
  \ 'do': 'make install'
\}




" Git
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'

" Initialize plugin system
call plug#end()

let mapleader = " " 


set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

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

" start scrolling 8 lines from the bottom instead of waiting until cursor is
" all the way down
set scrolloff=8

set signcolumn=yes

" set working directory relative to open buffer
set autochdir

" visual paste but don't replace buffer
vnoremap <leader>p "_dp

" hybrid line numbers
set number
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END


" Highlight search as you type
set incsearch

nnoremap <silent> <Leader>+ :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "vertical resize  " . (winwidth(0) * 2/3)<CR>

" Telescope
nnoremap <c-p> :lua require'telescope.builtin'.git_files{}<CR>

" Standard Vim Keymappings
"
" move line up/down
nnoremap <leader>k :m .-2<CR>==
nnoremap <leader>j :m .+1<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap K :m '<-2<CR>gv=gv
vnoremap J :m '>+1<CR>gv=gv

" remap capital Y to highlight to end of line
nnoremap Y y$


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
let NERDTreeWinSize=60
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>


" CoC 
" Remap keys for gotos
nmap <silent> <leader>gd <Plug>(coc-definition)
nmap <silent> <leader>gs :vsp<CR><Plug>(coc-definition)
nmap <silent> <leader>gt :vsp<CR><Plug>(coc-definition)<C-W>T
nmap <silent> <leader>gy <Plug>(coc-type-definition)
nmap <silent> <leader>gi <Plug>(coc-implementation)
nmap <silent> <leader>gr <Plug>(coc-references)
nmap <silent> <leader>ge <Plug>(coc-diagnostic-next)


" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph 
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)


" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Undo breakpoints
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ? ?<c-g>u
inoremap ! !<c-g>u



" Highlight  on yank plugin
let g:highlightedyank_highlight_duration = 300

" remap open split
let g:NERDTreeMapOpenVSplit = 'v'



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




lua require("lsp-config")
"lua require("treesitter")
