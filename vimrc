" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Required by Vundle
set nocompatible              " be iMproved, required
filetype off                   " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" " let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin '907th/vim-auto-save'
Plugin 'Valloric/YouCompleteMe'
Plugin 'klen/python-mode'
Plugin 'bling/vim-airline'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'airblade/vim-gitgutter'
Plugin 'kien/ctrlp.vim'
call vundle#end() " all of your Plugins must be added before the following line
" " Brief help
" " :PluginList       - lists configured plugins
" " :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" " :PluginSearch foo - searches for foo; append `!` to refresh local cache
" " :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal

if has("syntax")
  syntax on
endif

if has("autocmd")
  filetype plugin indent on
endif

" GENERAL VIM SETTINGS
set showmatch	           " Show matching brackets.
set ignorecase	           " Do case insensitive matching
set smartcase	           " Do smart case matching
set incsearch	           " Incremental search
set hlsearch               " Highlight matching search patterns
set mouse=a	           " Enable mouse usage (all modes)
set encoding=utf-8
set clipboard+=unnamedplus " use the clipboards of vim and win
set paste                  " Paste from a windows or from vim
set go+=a                  " Visual selection automatically copied to the clipboard
set foldminlines=20        " Fold only long functions or classes
set foldlevelstart=1       " Do not fold top-level function or classes
color molokai
set t_Co=256               " 256 colors of the terminal to support nicer themes
set background=dark        " Should be turned on when using syntax highlighting on dark background

" Leader shortcuts for system clipboard
let mapleader = "\<Space>"
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" Format XML files
set equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null


" PLUGIN SETTINGS
let g:auto_save = 1  " enable AutoSave on Vim startup
let g:pymode_rope = 1
let g:pymode_options_max_line_length = 120
let g:instant_markdown_autostart = 0 

" YouCompleteMe settings
let g:clang_user_options='|| exit 0'
let g:ycm_add_preview_to_completeopt=1
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_min_num_of_chars_for_completion=2
nnoremap <leader>jd :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>jf :YcmCompleter GoToDefinition<CR>

" Airline settings
let g:airline_theme='powerlineish'
let g:airline#extensions#tabline#enabled=1 " Enable fancy tab bar
let g:airline_powerline_fonts = 1
set laststatus=2 " Show airline even if there is only one buffer
set noshowmode " Disable standard mode description in favour of airline
let g:Powerline_symbols = "fancy"

" NERDTree settings
let NERDTreeDirArrows=0 " Fixes weird symbols in the tree
let NERDTreeIgnore = ['\.pyc$'] " Do not show these files in the tree
