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
Plugin '907th/vim-auto-save'  " Replace this with simple config
Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-syntastic/syntastic'
Plugin 'python-mode/python-mode'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'  " Replace this with simple command
Plugin 'kien/ctrlp.vim'            " Remove this?
Plugin 'suan/vim-instant-markdown'
Plugin 'kylef/apiblueprint.vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'virtualenv.vim'
Plugin 'vim-scripts/django.vim'
Plugin 'fisadev/vim-isort'
Plugin 'luochen1990/rainbow'
Plugin 'notpratheek/vim-luna'
Plugin 'wimstefan/Lightning'
Plugin 'lervag/vimtex'

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
set clipboard+=unnamedplus " use the clipboards of vim and X
set go+=a                  " Visual selection automatically copied to the clipboard
set foldminlines=20        " Fold only long functions or classes
set foldlevelstart=1       " Do not fold top-level function or classes
color luna-term            " luna-term for dark theme or lightning for a light theme
set t_Co=256               " 256 colors of the terminal to support nicer themes
set background=dark        " Should be turned on when using syntax highlighting on dark background
set number                 " Line numbers
set tabstop=4
set shiftwidth=4
set expandtab
set splitright
set undofile               " Maintain undo history between sessions
set undodir=~/.vim/undodir " Save the undo history here rather than in the current workdir
set path=**                " Search down in subfolders with tab completion for file-related tasks
set wildmenu               " Display all matching files/tags/commands/whatever when we tab complete

" Override comment colour
hi Comment ctermfg=244 

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
nnoremap nt :tabnew<CR>

" Quickfix navigation
nnoremap <leader>ln :lnext<CR>
nnoremap <leader>lp :lprevious<CR>
nnoremap <leader>lo :lopen<CR>
nnoremap <leader>lc :lclose<CR>

" Shortcut to copy current file path
nmap cp :let @" = expand("%")<cr><cr>

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

" Vimgrep customization
" opens search results in a window w/ links and highlight the matches

" Use The Silver Searcher if available and fallback to Grep otherwise
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l -g ""'
  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
  :nmap <leader>g :grep "\b<C-R><C-W>\b"<CR>:cw<CR>
  " Prepare Ag command to be mapped to a convenience key
  command -nargs=+ -complete=file -bar Ag silent! grep! "<args>" -S|cwindow|redraw!
  " map Ag to \
  nnoremap \ :Ag<SPACE>
else
  command! -nargs=+ Grep execute 'silent grep! -I -r -n --exclude *.{css,json,js} --exclude-dir .git --exclude-dir migrations --exclude-dir bower_components --exclude-dir node_modules --exclude-dir data --exclude-dir static --exclude-dir  media --exclude-dir out . -e <args>' | copen | execute 'silent /<args>' | execute ':redraw!'  
  " leader-G Greps for the word under the cursor
  :nmap <leader>g :Grep <c-r>=expand("<cword>")<cr><cr>
endif

" PLUGIN SETTINGS
let g:auto_save = 1  " enable AutoSave on Vim startup
let g:auto_save_in_insert_mode = 0  " do not save while in insert mode

let g:instant_markdown_autostart = 1

let g:gitgutter_max_signs = 1000

let g:rainbow_active = 1

let g:vim_isort_python_version = 'python3'

" Pymode settings
let g:pymode_lint = 0  " Disable to use linting from Syntastic
let g:pymode_options_max_line_length = 80
let g:pymode_indent = 1
let g:pymode_folding = 0
let g:pymode_motion = 1
let g:pymode_rope = 0

" Syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['flake8']

"Git Gutter settings
nmap <Leader>nh <Plug>GitGutterNextHunk
nmap <Leader>ph <Plug>GitGutterPrevHunk

" YouCompleteMe settings
let g:clang_user_options='|| exit 0'
let g:ycm_add_preview_to_completeopt=1
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_min_num_of_chars_for_completion=2
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_python_binary_path = '/usr/bin/python2'
nnoremap <leader>jd :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>jf :YcmCompleter GoToDefinition<CR>
noremap pumvisible() ? "\" : " "

" Airline settings
let g:airline_theme='luna' " luna for dark background or papercolor for the light background
let g:airline#extensions#tabline#enabled=1 " Enable fancy tab bar
let g:airline#extensions#virtualenv#enabled = 1
let g:airline_powerline_fonts = 1
set laststatus=2 " Show airline even if there is only one buffer
set noshowmode " Disable standard mode description in favour of airline
let g:Powerline_symbols = "fancy"


" NERDTree settings
let NERDTreeDirArrows=0 " Fixes weird symbols in the tree
let NERDTreeIgnore = ['\.pyc$', '__pycache__$'] " Do not show these files in the tree
nmap <leader>ne :NERDTree<cr>
map <leader>nf :NERDTreeFind<cr>

" C++ settings
let &makeprg='make -j8 -C ~/Archiv/TextSpotter/build'
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow
nmap <leader>m :make<cr>

" CtrlP settings
set wildignore+=*/media/*,*/site-packages/*,*/bower_components/*
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|ico|git|svn|pyc))$'
nnoremap <leader>ft :CtrlPTag<cr>

" Vimtex settings
let g:vimtex_latexmk_continuous=1
let g:vimtex_latexmk_options='-pdf -file-line-error -synctex=1 -interaction=nonstopmode -shell-escape'

" Automatically update copyright notice with current year
autocmd BufWritePre *
  \ if &modified |
  \   exe "g#\\cCOPYRIGHT \(C\) \\(".strftime("%Y")."\\)\\@![0-9]\\{4\\}\\(-".strftime("%Y")."\\)\\@!#s#\\([0-9]\\{4\\}\\)\\(-[0-9]\\{4\\}\\)\\?#\\1-".strftime("%Y") |
  \ endif
