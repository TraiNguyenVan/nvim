call plug#begin()

" List your plugins here
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Code intellisense
Plug 'neoclide/coc.nvim', 
			\ {'branch': 'release'}                     " Language server protocol (LSP) 
Plug 'jiangmiao/auto-pairs'                   " Parenthesis auto
Plug 'jackguo380/vim-lsp-cxx-highlight'       " C/C++

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

autocmd FileType cpp nmap <buffer> <F6> :w<bar>!alacritty -e sh -c './%:r && read -p "Press enter to continue"'<CR>
let file_name = expand('%:t:r')
let extension = expand('%:e')
let build_cmd = expand('g++ -o %:r %')
autocmd FileType cpp nmap <silent> <F5> :w<bar>!g++ -o %:r % && alacritty -e sh -c './%:r && read -p "Press enter to continue"'<CR>
