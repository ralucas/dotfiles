autocmd VimEnter * NERDTree
let NERDTreeShowHidden=1
set nocompatible
"filetype off
syntax enable
set background=dark
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags 
set lines=999 columns=9999
"let g:hybrid_use_iTerm_colors = 1
"let g:molokai_original = 1
colorscheme solarized 
"silent! colorscheme inori
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set number
set hidden
" GRB: use fancy buffer closing that doesn't close the split
cnoremap <expr> bd (getcmdtype() == ':' ? 'Bclose' : 'bd')
"sets incremental search
set incsearch
"sets highlight search
set hlsearch
set encoding=utf-8
set guifont=Anonymous\ Pro\ for\ Powerline:h18
set fillchars+=stl:\ ,stlnc:\
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
"set rtp+=~/.vim/bundle/vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'pangloss/vim-javascript'
Plugin 'scrooloose/nerdtree'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'tpope/vim-surround'
Plugin 'Lokaltog/powerline'
Plugin 'tpope/vim-markdown'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'othree/javascript-libraries-syntax.vim'
Plugin 'w0ng/vim-hybrid'
Plugin 'tomasr/molokai'
Plugin 'scrooloose/syntastic'
Plugin 'kovisoft/slimv'
Plugin 'Raimondi/delimitMate'
Plugin 'ervandew/supertab'
Plugin 'scrooloose/nerdcommenter'
Plugin 'tpope/vim-fugitive'
Plugin 'Valloric/YouCompleteMe'
Plugin 'mattn/emmet-vim'
Plugin 'duythinht/inori'
Plugin 'othree/html5.vim'
Plugin 'briancollins/vim-jst'
Plugin 'fholgado/minibufexpl.vim'
Plugin 'fatih/vim-go'
Plugin 'kchmck/vim-coffee-script'
call vundle#end()
inoremap jk <ESC>
let g:slimv_swank_cmd = '!osascript -e "tell application \"iTerm\" to do script \"sbcl --load ~/.vim/bundle/slimv/slime/start-swank.lisp\""'
filetype on
filetype plugin indent on

