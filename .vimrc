autocmd VimEnter * NERDTree
set nocompatible
filetype off
syntax enable
set background=dark
"let g:hybrid_use_iTerm_colors = 1
let g:molokai_original = 1
colorscheme molokai
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set number
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
filetype plugin indent on
inoremap jk <ESC>
