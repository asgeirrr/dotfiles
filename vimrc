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
Plugin 'scrooloose/nerdcommenter'
Plugin 'airblade/vim-gitgutter'
Plugin 'kien/ctrlp.vim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'suan/vim-instant-markdown'
Plugin 'kylef/apiblueprint.vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'octol/vim-cpp-enhanced-highlight'
Plugin 'mhinz/vim-signify'
Plugin 'vim-scripts/a.vim'
call vundle#end() " all of your Plugins must be added before the following line
" " Brief help
" " :PluginList       - lists configured plugins
" " :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" " :PluginSearch foo - searches for foo; append `!` to refresh local cache
" " :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal

filetype plugin indent on
syntax on

" GENERAL VIM SETTINGS
set showmatch	           " Show matching brackets.
set ignorecase	           " Do case insensitive matching
set smartcase	           " Do smart case matching
set incsearch	           " Incremental search
set hlsearch               " Highlight matching search patterns
set mouse=a	           " Enable mouse usage (all modes)
set encoding=utf-8
set clipboard+=unnamedplus " use the clipboards of vim and win
set go+=a                  " Visual selection automatically copied to the clipboard
set foldminlines=20        " Fold only long functions or classes
set foldlevelstart=1       " Do not fold top-level function or classes
color molokai
set t_Co=256               " 256 colors of the terminal to support nicer themes
set background=dark        " Should be turned on when using syntax highlighting on dark background
set number                 " Line numbers

" Leader shortcuts for system clipboard
let mapleader = "\<Space>"
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" Buffer navigation
map <tab> <C-w><C-w>
map <C-k> <C-w><Up>
map <C-j> <C-w><Down>
map <C-l> <C-w><Right>
map <C-h> <C-w><Left>

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" Format XML files
set equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null


" PLUGIN SETTINGS
let g:auto_save = 1  " enable AutoSave on Vim startup
let g:pymode_options_max_line_length = 120
let g:pymode_indent = 1
let g:pymode_folding = 1
let g:pymode_motion = 1
let g:pymode_lint_on_fly = 1
let g:pymode_lint_message = 1
let g:pymode_lint_cwindow = 0
let g:pymode_rope = 0
let g:pymode_rope_lookup_project = 0
let g:instant_markdown_autostart = 1
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|ico|git|svn|pyc))$'
let g:gitgutter_max_signs = 1000
let g:signify_vcs_list = [ 'svn', ]

" YouCompleteMe settings
let g:clang_user_options='|| exit 0'
let g:ycm_add_preview_to_completeopt=1
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_min_num_of_chars_for_completion=2
let g:ycm_collect_identifiers_from_tags_files = 0
nnoremap <leader>jd :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>jf :YcmCompleter GoToDefinition<CR>
noremap pumvisible() ? "\" : " "
" Airline settings
let g:airline_theme='powerlineish'
let g:airline#extensions#tabline#enabled=1 " Enable fancy tab bar
let g:airline_powerline_fonts = 1
set laststatus=2 " Show airline even if there is only one buffer
set noshowmode " Disable standard mode description in favour of airline
let g:Powerline_symbols = "fancy"
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

" NERDTree settings
let NERDTreeDirArrows=0 " Fixes weird symbols in the tree
let NERDTreeIgnore = ['\.pyc$'] " Do not show these files in the tree
nmap <leader>ne :NERDTree<cr>
" C++ settings
let &makeprg='make -j8 -C ~/Archiv/TextSpotter/build'
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
set tabstop=4
set shiftwidth=4
set expandtab
let g:ycm_collect_identifiers_from_tags_files = 1
set tags+=./tags
nmap <leader>m :make<cr>

