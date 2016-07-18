" VIMRC


" General
set ruler
nmap ; :

let mapleader = "\<Space>"
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>

" use jk to escape 
inoremap jk <C-[>

" set paste/nopaste
set pastetoggle=<F10>


" Backup and Swap Files
set nobackup                     " no backup~ files
set noswapfile                   " disable swap file


" Code Folding
if v:version >= 703
   set foldenable                " enable folding
   set foldlevelstart=10         " fold code blocks where depth>10 on start
   set foldmethod=indent         " detect folding using indents
endif


" Colors and Fonts
syntax enable                    " enable syntax highlighting
set background=dark              " dark background

if v:version >= 703
   colorscheme darkblue          " color scheme: desert 
endif


" Editing
set backspace=indent,eol,start


" History
set hidden                       " remember undo after quitting
set history=1000
set undofile
set undodir=~/.vim/undodir

if has("autocmd")                " remember last position in file
   au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif


" Movement

" wrap left and right to end and beginning of lines
set whichwrap+=>,l
set whichwrap+=<,h

" use Ctrl+l to move to next tab
nnoremap <silent> <C-l> gt

" use Ctrl+h to move to previous tab
nnoremap <silent> <C-h> gT


" Mouse
"set mouse=a


" Plugins
filetype plugin on

map <Leader>nt :NERDTreeToggle<CR>```
nnoremap <Leader>o :CtrlP<CR>

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)


" Searching
set hlsearch                     " highlight searches (use :noh to disable highlight)
set ignorecase                   " ignore case when searching
set incsearch                    " search as characters are entered
set smartcase                    " use case when searching /Search but not /search


" Sounds
set noerrorbells                 " no beep
set visualbell                   " no beep


" Tabs
filetype indent on               " allow indenting by filetype
set expandtab                    " replace tabs with spaces
set shiftwidth=3
set smartindent                  " add indents on the next line after {

" allow indented comments starting with #
inoremap # X#

set softtabstop=3                " number of spaces added or deleted when using tab
set tabstop=3                    " number of visual spaces per tab


" UI
set cursorline                   " highlight current line
set lazyredraw                   " no redraws in macros
set number                       " show line numbers
set scrolloff=2                  " 2 lines above/below cursor when scrolling
set showcmd                      " show command in bottom bar
set showmatch                    " highlight matching [{()}]
set showmode                     " show mode in status bar (insert/replace/...)
set title                        " show file in titlebar
set wildmenu                     " visual autocomplete for command menu, e.g. autocomplete filenames for :e ~/.vim<TAB>
set wrap                         " wrap lines


execute pathogen#infect()
