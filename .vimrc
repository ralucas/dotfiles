autocmd VimEnter * NERDTree
set nocompatible
filetype off
syntax enable
set background=dark
"let g:hybrid_use_iTerm_colors = 1
"let g:molokai_original = 1
colorscheme solarized 
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set number
"sets incremental search
set incsearch
"sets highlight search
set hlsearch
set encoding=utf-8
set guifont=Anonymous\ Pro\ for\ Powerline
set fillchars+=stl:\ ,stlnc:\
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
set rtp+=~/.vim/bundle/vundle
call vundle#rc()
Plugin 'gmarik/vundle'
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
Plugin 'scrooloose/nerdcommenter'
Plugin 'Raimondi/delimitMate'
Plugin 'ervandew/supertab'
filetype plugin indent on
inoremap jk <ESC>
let g:slimv_swank_cmd = '!osascript -e "tell application \"iTerm\" to do script \"sbcl --load ~/.vim/bundle/slimv/slime/start-swank.lisp\""'

