call plug#begin()

" List your plugins here
Plug 'vim-airline/vim-airline'   			  " Status line
Plug 'vim-airline/vim-airline-themes'

Plug 'navarasu/onedark.nvim'

Plug 'neoclide/coc.nvim', 
			\ {'branch': 'release'}                     " Language server protocol (LSP) 
Plug 'jiangmiao/auto-pairs'                   " Parenthesis auto
Plug 'tpope/vim-fugitive'                     " Git infomation 
Plug 'tpope/vim-rhubarb' 
Plug 'airblade/vim-gitgutter'                 " Git show changes 
Plug 'samoshkin/vim-mergetool'                " Git merge

Plug 'preservim/nerdTree'                     " File browser  
Plug 'Xuyuanp/nerdtree-git-plugin'            " Git status
Plug 'ryanoasis/vim-devicons'                 " Icon
Plug 'unkiwii/vim-nerdtree-sync'              " Sync current file 
Plug 'jcharum/vim-nerdtree-syntax-highlight',

Plug 'sheerun/vim-polyglot'

call plug#end()

let g:airline_theme='deus'
let g:airline#extensions#tabline#enabled = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.dirty='⚡'

let mapleader = "\<Space>"
nnoremap <silent><leader>bd :<C-U>bprevious <bar> bdelete #<CR>
map <silent> <F2> :NERDTreeToggle<CR>
nnoremap <silent><leader>e :NERDTreeFocus<CR>
let g:NERDTreeGitStatusIndicatorMapCustom = {
            \ 'Modified'  : '',   
            \ 'Staged'    : '',   
            \ 'Untracked' : '',   
            \ 'Renamed'   : '',   
            \ 'Unmerged'  : '',   
            \ 'Deleted'   : '',   
            \ 'Dirty'     : '',   
            \ 'Ignored'   : '',   
            \ 'Clean'     : '',   
            \ 'Unknown'   : '',   
            \ }
" Exit Vim if NERDTree is the only window left.
" autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif


autocmd FileType cpp nmap <buffer> <F6> :w<bar>!alacritty -e sh -c './%:r && read -p "Press enter to continue"'<CR>
autocmd FileType cpp nmap <silent> <F5> :w<bar>!g++ -o %:r % && alacritty -e sh -c './%:r && read -p "Press enter to continue"'<CR>

set tabstop=4
colorscheme onedark

set termguicolors
