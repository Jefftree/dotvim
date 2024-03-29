set nocompatible
"set all& "reset
" Do we even need this?
let s:is_windows = has('win32') || has('win64')
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" leader to comma
let mapleader = ","
let g:mapleader = ","
let maplocalleader = "\\"
let g:localleader = "\\"

let $DOTFILES=(expand('~/.dotfiles'))

" File extension corrections
augroup ext_syntax
  autocmd!
  au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
  au BufNewFile,BufFilePre,BufRead .*rrc,.*lrc set filetype=vim
  au BufNewFile,BufFilePre,BufRead vimrc set filetype=vim
  au BufNewFile,BufFilePre,BufRead *.wlp4 set filetype=c

  au BufWritePost * Neomake
  au BufRead * Neomake

  "au BufRead *.html set filetype=htmlm4
augroup END

set timeoutlen=2000   " mapping timeout
set ttimeoutlen=50    " keycode timeout
set nofoldenable      " disable folding
set mouse=a           " enable mouse
set history=1000      " number of command lines to remember
set ttyfast           " assume fast terminal connection
set encoding=utf-8    " set encoding for text
set hidden            " allow buffer switching without saving
set autoread          " auto reload if file saved externally
set noshowcmd         " Don't show last cmd, faster
set autochdir         " automatically change to file dir
set clipboard=unnamed " Share clipboard with OS

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if s:is_windows
    set rtp+=~/.vim
endif

" Plugins will be downloaded under the specified directory.
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'junegunn/seoul256.vim'

" Interface
Plug 'flazz/vim-colorschemes'          " List of common color themes
Plug 'bling/vim-airline'               " Status bar
Plug 'vim-airline/vim-airline-themes'  " Airline colors
Plug 'airblade/vim-gitgutter'          " Gitgutter
Plug 'mhinz/vim-startify'              " More useful startup page

Plug 'kien/ctrlp.vim'                  " File searcher
Plug 'qpkorr/vim-bufkill'              " Close buffer without closing window
Plug 'tpope/vim-commentary'            " Commenting shortcuts
Plug 'neomake/neomake'                 " Neomake
Plug 'tpope/vim-fugitive'              " Git
Plug 'tpope/vim-surround'              " Surround shortcuts
Plug 'tpope/vim-repeat'                " Repeat stuff
Plug 'godlygeek/tabular'               " Easy alignment of variables
Plug 'Raimondi/delimitMate'            " Matching parentheses
Plug 'mbbill/undotree'                 " Undo tree
Plug 'benmills/vimux'                  " tmux + vim
Plug 'wellle/targets.vim'              " Edit Motions

" Language specific
Plug 'pangloss/vim-javascript'         " Javscript indentations
Plug 'elzr/vim-json'                   " JSON Highlighting
Plug 'mxw/vim-jsx'                     " JSX for React.js
Plug 'tpope/vim-markdown'              " Markdown support
Plug 'tmux-plugins/vim-tmux'           " tmux file highlighting

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

filetype plugin indent on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" JSX Enabled on all JS Files
let g:jsx_ext_required = 0

" Auto open new line indentation after {<cr>
let delimitMate_expand_cr = 1

" Vimux split fun
let g:VimuxOrientation = "v"
let g:VimuxHeight = "10"

map [compile] <Nop>
autocmd Filetype python nmap <silent> <buffer> [compile] :call VimuxRunCommand("python ".bufname("%"))<CR>
autocmd Filetype c,cpp,cc nmap <silent> <buffer> [compile] :call VimuxRunCommand("g++ ".bufname("%")." && ./a.out")<CR>

map [test] <Nop>
autocmd Filetype python nmap <silent> <buffer> [test] :call VimuxRunCommand("ts ".bufname("%"))<CR>

nmap <leader>n [test]
nmap <leader>m [compile]

function! Light()
    let g:airline_theme='tomorrow'
    colorscheme Tomorrow
    hi clear Conceal
endfunction

function! Dark()
    let g:airline_theme='wombat'
    colorscheme jellybeans
    hi CursorLine ctermbg=17
    hi clear Conceal
endfunction

nnoremap <leader>l :call Light()<CR>
nnoremap <leader>k :call Dark()<CR>

" Definition text object
vnoremap id :<C-U>silent! normal! 0vt:<CR>
omap id :normal vid<CR>

" Bolds definition object. Could probably remap to <C-b> in insert mode LOL
nmap gb ysid*.

nnoremap <silent> <F5> :UndotreeToggle<CR>

" CTRL-P
let g:ctrlp_cache_dir = $USERPROFILE . '/.cache/ctrlp'
let g:ctrlp_reuse_window='startify'
let g:ctrlp_custom_ignore = '\v[\/](\.(git|hg|svn|idea)|node_modules|coverage|bower_components)$'
let g:ctrlp_max_height=5
let g:ctrlp_max_files=20000
let g:ctrlp_show_hidden=0

" Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
if executable('ag')
  let g:ctrlp_user_command = 'ag -l --nocolor -g "" %s'
endif

" Airline tabline
let g:airline_theme='wombat'
let g:airline_left_sep=''
let g:airline_right_sep=''

" Startify
let g:startify_change_to_vcs_root = 1
let g:startify_session_persistence = 0		" automatically update sessions
let g:startify_show_sessions = 1
nnoremap <F1> :Startify<cr>

" Git
nnoremap <silent> <leader>ga :Git add %:p<CR><CR>
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gc :Gcommit -v -q<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable                  " Enable syntax highlighting

set wildmenu                   " Expands autocompletion stuff in cmd mode
set wildmode=list:longest,full " List completion. Similar to zsh
set wildignorecase
set wildignore=*.o,*~,*.pyc    " Ignore compiled files
set wildignore+=*DS_Store*
set wildignore+=*.png,*.jpg,*.gif

set ruler                      " Show cursor position
set cmdheight=1                " Lines to use for cmd line

set backspace=eol,start,indent " Backspaces solos everything
set whichwrap+=<,>,h,l         " move to next line after line end

set ignorecase                 " ignore case when searching
set smartcase                  " case-sensitive if uppercase search
set hlsearch                   " Highlight search results
set incsearch                  " Show search matches as you type
set wrapscan                   " Searches wrap after hitting end
set magic                      " Regex is love regex is life
set showmatch                  " Show matching brackets when text indicator is over them
set matchtime=2                " Time limit for matching brackets
set lazyredraw                 " less is more
set noshowmode                 " don't show current mode
set nowrap                     " don't wrap lines
set number                     " Line numbers
set relativenumber             " Relative numbers
set cursorline                 " Highlight cursor line
set synmaxcol=200              " Don't highlight long lines

set shortmess+=I               " No annoying startup message
set scrolloff=10               " Don't let cursor be near vertical edge of screen
set laststatus=2               " Always show the status line

set expandtab                  " Use spaces instead of tabs
set smarttab                   " insert tabs according to shiftwidth, not tabstop
set shiftwidth=2 tabstop=2     " 1 tab == 2 spaces; I love javascript
set shiftround                 " use multiple of shiftwidth when indenting with '<' and '>'

set autoindent                 " always set autoindenting on
set copyindent                 " copy the previous indentation on autoindenting

set noerrorbells novisualbell  " No annoying sound on errors
set t_vb=
set tm=500

set nobackup nowb noswapfile   " Turn backup off

set tags=tags;/                " Recursive tag search

" Undotree
if has("persistent_undo")
    if !isdirectory(expand('~').'/.vim/.undodir')
        silent !mkdir ~/.vim/.undodir > /dev/null
    endif
    set undodir=~/.vim/.undodir
    set undofile
    set undolevels=1000 "maximum number of changes that can be undone
    set undoreload=10000 "maximum number lines to save for undo on a buffer reload
endif

if executable('ag')
    set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
    set grepformat=%f:%l:%c:%m
endif

nnoremap <leader>fw :execute "vimgrep ".expand("<cword>")." %"<cr>:copen<cr>
nnoremap <leader>ff :execute 'vimgrep /'.@/.'/g %'<cr>:copen<cr>

"""""""""""""""""""""""""""""""""""
" Command Mode
"""""""""""""""""""""""""""""""""""
" Bash like keys for the command line.
 cnoremap <c-a> <home>
 cnoremap <c-e> <end>
 cnoremap <c-h> <s-left>
 cnoremap <c-l> <s-right>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Splitting shortcuts and defaults
set splitright
set splitbelow

nnoremap <leader>s :sp<CR>
nnoremap <leader>v :vsp<CR>

vmap <leader>s :sort<CR>

" Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" insert-mode escapes
inoremap jj <Esc>
inoremap kj <Esc>
inoremap jk <Esc>

" Center screen when searching and jumping
nnoremap n nzz
nnoremap N Nzz
nnoremap { {zz
nnoremap } }zz

" Consistent yanking
nnoremap Y y$

" Windows navigation shortcut
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Hide quit message
nnoremap <C-c> <C-c>:echo<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Unhighlight search results
nnoremap <silent> <BS> :set hlsearch! hlsearch?<cr>

" Swap between header and implementation file
nnoremap <F6> :e %:p:s,.h$,.X123X,:s,.cc$,.h,:s,.X123X$,.cc,<CR>

" Quick access to config files. TODO: May need to remap
nmap <leader>, :e ~/.vim/vimrc<CR>

" Faster saving
nmap <leader>w :w!<cr>
nmap <leader>e :w !sudo tee > /dev/null %<cr>

" Easy way to peace vim
nmap <leader>x :x<CR>

" Apply vimrc changes without restart
nmap <silent> <leader>r :so $MYVIMRC<CR>

" Easy buffer navigation using tabs
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

" Remap VIM 0 to first non-blank character
nnoremap 0 ^
nnoremap ^ 0

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" Reindent
nnoremap R mzgg=G`z

" TODO: Delete trailing white space on save
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

autocmd BufWrite *.py,*.md,*.js :call DeleteTrailingWS()

" Reselect paste
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" makefile tab indent correction
augroup tab_config
  autocmd!
  au FileType make setlocal noexpandtab
  au FileType yaml setlocal shiftwidth=2 tabstop=2
  au FileType cfg setlocal shiftwidth=1 tabstop=1
  au FileType js setlocal shiftwidth=2 tabstop=2
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => GUI
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Reduce annoying split line impact
set fillchars+=vert:.
hi! VertSplit ctermfg=234 ctermbg=234 term=NONE

if has('gui_running')
    colorscheme jellybeans
    set guifont=Inconsolata-dz:h10 " Eyesight must be getting better
    "set guifont=Inconsolata:h11:cANSI
    if !has("gui_macvim")
        au GUIEnter * simalt ~x "Windows Full Screen"
    endif
    set guiheadroom=0
    set guioptions-=m  "remove menu bar
    set guioptions-=T  "remove toolbar
    set guioptions-=r  "remove right-hand scroll bar
    set guioptions-=L  "remove left-hand scroll bar
    set guicursor+=n-v-c:blinkon0
    hi CursorLine term=bold cterm=bold guibg="1c136f
    highlight Cursor guifg=black guibg="65e770
    highlight iCursor guifg=black guibg="65e770
    hi clear Conceal
elseif (&term =~ "xterm" || &term =~ "screen-256color" || &term =~ "rxvt-unicode-256color")
    set t_Co=256
    "let g:airline_theme='tomorrow'
    "colorscheme Tomorrow

    set background=dark
    colorscheme jellybeans
    hi CursorLine ctermbg=17
    hi clear Conceal
endif
