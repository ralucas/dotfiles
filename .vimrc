set nocompatible
filetype off
syntax enable
set background=dark
colorscheme solarized
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set number
set encoding=utf-8
set fillchars+=stl:\ ,stlnc:\
set rtp+=~/.vim/bundle/vundle
call vundle#rc()
Plugin 'gmarik/vundle'
Plugin 'Markdown'
Plugin 'jQuery'
Plugin 'git.zip'
Plugin 'pangloss/vim-javascript'
Plugin 'scrooloose/nerdtree'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'tpope/vim-surround'
filetype plugin indent on
inoremap jk <ESC>
