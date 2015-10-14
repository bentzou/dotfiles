" VIMRC


" General
set ruler
nmap ; :

" use jk to escape 
inoremap jk <C-[>

" set paste/nopaste
set pastetoggle=<F10>


" Backup and Swap Files
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
   colorscheme desert            " color scheme: desert 
endif


" History
set history=1000


" Movement

" wrap left and right to end and beginning of lines
set whichwrap+=>,l
set whichwrap+=<,h

" use Ctrl+l to move to next tab
nnoremap <silent> <C-l> gt

" use Ctrl+h to move to previous tab
nnoremap <silent> <C-h> gT


" Mouse
set mouse=a


" Searching
set hlsearch                     " highlight searches (use :noh to disable highlight)
set ignorecase                   " ignore case when searching
set incsearch                    " search as characters are entered
set smartcase                    " use case when searching /Search but not /search


" Sounds
set noerrorbells                 " no beep
set visualbell                   " no beep


" Tabs
set expandtab                    " replace tabs with spaces
set shiftwidth=3
set smartindent                  " add indents on the next line after {

" allow indented comments starting with #
inoremap # X#

set softtabstop=3                " number of spaces added or deleted when using tab
set tabstop=3                    " number of visual spaces per tab


" UI
set cursorline                   " highlight current line
set lazyredraw                   " redraw only when necessary
set nowrap                       " don't wrap lines
set number                       " show line numbers
set showcmd                      " show command in bottom bar
set showmatch                    " highlight matching [{()}]
set wildmenu                     " visual autocomplete for command menu, e.g. autocomplete filenames for :e ~/.vim<TAB>
