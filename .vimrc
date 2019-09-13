if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'ajh17/spacegray.vim'
Plug 'keith/swift.vim'
Plug 'kien/ctrlp.vim'
Plug 'lervag/vimtex'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-fugitive' 
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'udalov/kotlin-vim'
Plug 'guns/vim-clojure-static'

call plug#end()"

filetype plugin indent on
syntax on

let g:syntastic_swift_checkers = ['swiftlint', 'swiftpm']
let g:syntastic_swift_swiftlint_use_defaults = 1 

set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set backspace=2
set relativenumber
set number

colorscheme spacegray

" Mappings
nmap <F6> :NERDTreeToggle<CR>

