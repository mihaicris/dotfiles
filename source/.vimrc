if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'ajh17/spacegray.vim'
Plug 'keith/swift.vim'
Plug 'kien/ctrlp.vim'
"Plug 'lervag/vimtex'
Plug 'prabirshrestha/async.vim'
"Plug 'prabirshrestha/vim-lsp'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'psliwka/vim-smoothie'
Plug 'jose-elias-alvarez/null-ls.nvim'
"Plug 'udalov/kotlin-vim'
"Plug 'guns/vim-clojure-static'

call plug#end()"

filetype plugin indent on
syntax on

let g:syntastic_swift_checkers = ['swiftlint', 'swiftpm']
let g:syntastic_swift_swiftlint_use_defaults = 1
let NERDTreeShowHidden=1
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
" F5 delete all trailing whitespace
nnoremap <silent> <F5> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

" Tab, spaces
set tabstop=4 shiftwidth=4 expandtab

set backupdir=$TMPDIR
set directory=$TMPDIR
set undodir=$TMPDIR

" Show trailing blanks
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

