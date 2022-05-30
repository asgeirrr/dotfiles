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
Plugin 'maralla/completor.vim'
Plugin 'python-mode/python-mode'
Plugin 'itchyny/lightline.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'  " Replace this with simple command
Plugin 'suan/vim-instant-markdown'
Plugin 'kylef/apiblueprint.vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'virtualenv.vim'
Plugin 'vim-scripts/django.vim'
Plugin 'luochen1990/rainbow'
Plugin 'notpratheek/vim-luna'
Plugin 'wimstefan/Lightning'
Plugin 'lervag/vimtex'
Plugin 'w0rp/ale'
Plugin 'junegunn/fzf.vim'
Plugin 'wimstefan/vim-artesanal'
Plugin 'tpope/vim-surround'


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

" Enable syntax highlighting on weird file types
autocmd BufNewFile,BufRead *.geojson set syntax=json

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
set nofoldenable           " Do not fold top-level function or classes
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
set tags=.git/tags
set number relativenumber

" Make Python available in NeoVim
let g:python_host_prog = 'python3'

" Override comment colour
hi Comment ctermfg=244

" Filetype settings
autocmd FileType gitcommit,rst,markdown setlocal spell

" Disable arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" Leader shortcuts for system clipboard
let mapleader = "\<Space>"
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" Buffer navigation
map <C-k> <C-w><Up>
map <C-j> <C-w><Down>
map <C-l> <C-w><Right>
map <C-h> <C-w><Left>
nnoremap nt :tabnew<CR>
tnoremap <C-o> <C-\><C-n>

" Quickfix navigation
nnoremap <leader>ln :lnext<CR>
nnoremap <leader>lp :lprevious<CR>
nnoremap <leader>lo :lopen<CR>
nnoremap <leader>lc :lclose<CR>

" Shortcut to copy current file path
nmap cp :let @+ = expand("%")<cr><cr>

" Run Python tests in the current file
map <leader>t :!pytest % -vv<cr>

" Run Python tests in the current file
map <leader>k :!black %<cr>

" Run Cargo
map <leader>r :!RUST_BACKTRACE=1 cargo run<cr>

" Git shortcuts
map <leader>gb :terminal tig blame %<cr><cr>
map <leader>gh :terminal tig --follow %<cr><cr>

" Python dicts to JSON
map <leader>j :%s/'/"/g <bar> :%s/None/null/g <bar> :%s/True/true/g <bar> :%s/False/false/g <cr><cr>

" Vimgrep customization
" opens search results in a window w/ links and highlight the matches

" Use The Silver Searcher if available and fallback to Grep otherwise
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
  set grepprg=ag\ --vimgrep\ --smart-case
  :nmap <leader>g :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
  " Prepare Ag command to be mapped to a convenience key
  command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
  nnoremap \ :Ag<SPACE>
else
  command! -nargs=+ Grep execute 'silent grep! -I -r -n --exclude *.{css,json,js} --exclude-dir .git --exclude-dir migrations --exclude-dir bower_components --exclude-dir node_modules --exclude-dir data --exclude-dir static --exclude-dir  media --exclude-dir out . -e <args>' | copen | execute 'silent /<args>' | execute ':redraw!'
  " leader-G Greps for the word under the cursor
  :nmap <leader>g :Grep <cword> *<cr>
endif

" PLUGIN SETTINGS
let g:auto_save = 1  " enable AutoSave on Vim startup

let g:instant_markdown_autostart = 0

let g:gitgutter_max_signs = 1000
autocmd BufWritePost * GitGutter  " update signs on save

let g:rainbow_active = 1

" Pymode settings
let g:pymode_lint = 0  " Disable to use linting from ALE
let g:pymode_options_max_line_length = 99
let g:pymode_indent = 1
let g:pymode_folding = 0
let g:pymode_motion = 1
let g:pymode_rope = 0
let g:pymode_motion = 0

" ALE linter settings
nmap <Leader>pl <C-k> <Plug>(ale_previous_wrap)
nmap <silent>nl <C-j> <Plug>(ale_next_wrap)
let g:ale_linters = {'python': ['pylint', 'mypy']}
let g:ale_fixers = ['isort']
let g:ale_fix_on_save = 1

"Git Gutter settings
nmap <Leader>hn <Plug>(GitGutterNextHunk)
nmap <Leader>hp <Plug>(GitGutterPrevHunk)

" Completer settings
let g:completor_python_binary = '/usr/bin/python'
let g:completor_racer_binary = '~/.cargo/bin/racer'
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"
" Show doc string for the word under cursor (capital K)
noremap <s-k> :call completor#do('doc')<CR>

" Lightline settings
set laststatus=2 " Show lightline even if there is only one buffer
let g:lightline = {
            \ 'colorscheme': 'seoul256',
            \ 'component_function': {
            \   'filename': 'FilenameForLightline'
            \ }
            \ }

" Show full path of filename
function! FilenameForLightline()
    return expand('%')
endfunction

" NERDTree settings
let NERDTreeDirArrows=0 " Fixes weird symbols in the tree
let NERDTreeIgnore = ['\.pyc$', '__pycache__$'] " Do not show these files in the tree
nmap <leader>fe :NERDTree<cr>
map <leader>fs :NERDTreeFind<cr>

" FZF settings
let g:fzf_layout = { 'down': '~40%' }
nnoremap <leader>ff :FZF<cr>
nnoremap <leader>ft :Tags<cr>
nnoremap <leader>fa :Ag<cr>
nnoremap <leader>fh :History<cr>
nnoremap <leader>fg :GFiles?<cr>
nnoremap <leader>fc :History:<cr>
nnoremap <leader>fb :BTags<cr>
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" --no-merges'
nnoremap <C-]> :call fzf#vim#tags('^' . expand('<cword>'), {'options': '--exact --select-1 --exit-0 +i'})<CR>

" Vimtex settings
let g:tex_flavor = 'latex'
let g:vimtex_latexmk_continuous=1
let g:vimtex_latexmk_options='-pdf -file-line-error -synctex=1 -interaction=nonstopmode -shell-escape'

" Automatically update copyright notice with current year
autocmd BufWritePre *.py
  \ if &modified |
  \   exe "g#\\cCOPYRIGHT \(C\) \\(".strftime("%Y")."\\)\\@![0-9]\\{4\\}\\(-".strftime("%Y")."\\)\\@!#s#\\([0-9]\\{4\\}\\)\\(-[0-9]\\{4\\}\\)\\?#\\1-".strftime("%Y") |
  \ endif

" Neovim settings
if has('nvim')
    autocmd TermOpen term://* startinsert
endif

" Abbreviations
ab flexmock( flexmock() \<CR>.should_receive() \<CR>.with_args() \<CR>.and_return() \<CR>.once()<esc>4k2h
