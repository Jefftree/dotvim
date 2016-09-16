set nocompatible
"set all& "reset
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
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
au BufNewFile,BufFilePre,BufRead .*rrc,.*lrc set filetype=vim
au BufNewFile,BufFilePre,BufRead vimrc set filetype=vim
au BufNewFile,BufFilePre,BufRead *.wlp4 set filetype=c
au BufNewFile,BufFilePre,BufRead *.xtx set filetype=tex
"au BufRead *.html set filetype=htmlm4

" makefile tab indent correction
au FileType make setlocal noexpandtab
au FileType yaml setlocal shiftwidth=2 tabstop=2
au FileType cfg setlocal shiftwidth=1 tabstop=1
au FileType js setlocal shiftwidth=2 tabstop=2

set timeoutlen=2000   " mapping timeout
set ttimeoutlen=50    " keycode timeout
set nofoldenable      " disable folding
set mouse=a           " enable mouse
set history=1000      " number of command lines to remember
set ttyfast           " assume fast terminal connection
set encoding=utf-8    " set encoding for text
set hidden            " allow buffer switching without saving
set autoread          " auto reload if file saved externally
set showcmd           " always show last used command
set autochdir         " automatically change to file dir
set clipboard=unnamed " Share clipboard with OS

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if s:is_windows
    set rtp+=~/.vim
endif
set rtp+=~/.vim/bundle/neobundle.vim
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

" Interface
NeoBundle 'flazz/vim-colorschemes'          " List of common color themes
NeoBundle 'bling/vim-airline'               " Status bar
NeoBundle 'vim-airline/vim-airline-themes'  " Airline colors
NeoBundle 'airblade/vim-gitgutter'          " Gitgutter
NeoBundle 'luochen1990/rainbow'             " double rainbow
NeoBundle 'mhinz/vim-startify'              " More useful startup page
NeoBundle 'xolox/vim-colorscheme-switcher', {
            \ 'depends' : 'xolox/vim-misc'}  " Quickswitch theme

" Functionality

if has('lua')
    NeoBundle 'Shougo/neosnippet'               " Snippets functionality
    NeoBundle 'Shougo/neosnippet-snippets'      " Useful snippets
    NeoBundle 'Shougo/neocomplete.vim'          " Completion
endif

NeoBundle 'kien/ctrlp.vim'                  " File searcher
NeoBundle 'qpkorr/vim-bufkill'              " Close buffer without closing window
NeoBundle 'scrooloose/nerdtree'             " File explorer
NeoBundle 'scrooloose/nerdcommenter'        " Commenting shortcuts
NeoBundle 'scrooloose/syntastic'            " Syntax errors
NeoBundle 'tpope/vim-fugitive'              " Git
NeoBundle 'tpope/vim-surround'              " Surround shortcuts
NeoBundle 'tpope/vim-repeat'                " Repeat stuff
NeoBundle 'godlygeek/tabular'               " Easy alignment of variables
NeoBundle 'Raimondi/delimitMate'            " Matching parentheses
NeoBundle 'nathanaelkane/vim-indent-guides' " Indent visuals
NeoBundle 'majutsushi/tagbar'               " Tag browsing
NeoBundle 'rking/ag.vim'                    " Searcher
NeoBundle 'mbbill/undotree'                 " Undo tree
NeoBundle 'benmills/vimux'                  " tmux + vim
"NeoBundle 'christoomey/vim-tmux-navigator'  " easier tmux navigation
NeoBundle 'jceb/vim-orgmode'                " Might be useful
NeoBundle 'mattn/emmet-vim'                 " HTML Love
NeoBundle 'craigemery/vim-autotag'          " Auto reload ctags on save

" Language specific
NeoBundle 'pangloss/vim-javascript'         " Javscript indentations
NeoBundle 'elzr/vim-json'                   " JSON Highlighting
NeoBundle 'mxw/vim-jsx'                     " JSX for React.js
NeoBundle 'tpope/vim-markdown'              " Markdown support
NeoBundle 'vim-pandoc/vim-pandoc'           " Pandoc
NeoBundle 'vim-pandoc/vim-pandoc-syntax'    " Pandoc Syntax
NeoBundle 'tmux-plugins/vim-tmux'           " tmux file highlighting
NeoBundle 'PotatoesMaster/i3-vim-syntax'    " i3 highlighting
NeoBundle 'wlangstroth/vim-racket'          " Racket
NeoBundle 'keith/swift.vim'                 " Swift

NeoBundleLazy 'gregsexton/gitv', {'depends':['tpope/vim-fugitive'], 'autoload':{'commands':'Gitv'}} "{{{
    nnoremap <silent> <leader>gv :Gitv<CR>
    nnoremap <silent> <leader>gV :Gitv!<CR>
"}}}

call neobundle#end()
filetype plugin indent on
NeoBundleCheck " Check for missing plugins on startup

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" No need to spell check strings
let g:pandoc#spell#enabled = 0

let g:syntastic_enable_racket_racket_checker = 1

" Behaviour of this is kinda unpredictable. Look into it
"let g:user_emmet_expandabbr_key='<Tab>'

if has('lua')
    let g:neocomplete#enable_at_startup=1

    imap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ? "\<C-n>" : emmet#expandAbbrIntelligent("\<TAB>"))
    smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
    imap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""
    smap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""

    " Just for u colin
    imap <expr><Up> pumvisible() ? neocomplete#smart_close_popup() . "\<Up>" : "<Up>"
    imap <expr><Down> pumvisible() ? neocomplete#smart_close_popup() . "\<Down>" : "<Down>"
endif

" JSX Enabled on all JS Files
let g:jsx_ext_required = 0

" Auto open new line indentation after {<cr>
"inoremap {<CR> {<CR>}<Esc>ko
let delimitMate_expand_cr = 1

" Vimux split fun
let g:VimuxOrientation = "v"
let g:VimuxHeight = "10"

map [compile] <Nop>
autocmd Filetype pandoc nmap <silent> <buffer> [compile] :Pandoc -s --mathjax<CR>
autocmd Filetype tex nmap <silent> <buffer> [compile] :call VimuxRunCommand("xelatex ".bufname("%"))<CR>
autocmd Filetype racket nmap <silent> <buffer> [compile] :call VimuxRunCommand("racket ".bufname("%"))<CR>
autocmd Filetype python nmap <silent> <buffer> [compile] :call VimuxRunCommand("python ".bufname("%"))<CR>
autocmd Filetype c,cpp,cc nmap <silent> <buffer> [compile] :call VimuxRunCommand("g++ ".bufname("%")." && ./a.out")<CR>


map [test] <Nop>
autocmd Filetype python nmap <silent> <buffer> [test] :call VimuxRunCommand("ts ".bufname("%"))<CR>
autocmd Filetype pandoc nmap <silent> <buffer> [test] :Pandoc -s --mathjax pdf<CR>
autocmd Filetype pandoc nmap <silent> <buffer> [test] :call VimuxRunCommand("notes ".bufname("%")." pdf")<CR>
"autocmd Filetype tex nmap <silent> <buffer> [test] :call VimuxRunCommand("pdflatex ".bufname("%"))<CR>
nmap <leader>n [test]

" Probably need a more logical mapping lol
nmap <leader>m [compile]

function Light()
    let g:airline_theme='tomorrow'
    colorscheme Tomorrow
    hi clear Conceal
endfunction

function Dark()
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

nnoremap <leader>p :CtrlPTag<CR>
nnoremap <leader>o :CtrlPBuffer<CR>

" Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
if executable('ag')
  let g:ctrlp_user_command = 'ag -l --nocolor -g "" %s'
endif

" NERDtree file explorer
let NERDTreeQuitOnOpen=0
let NERDTreeIgnore=['\.git','\.hg','\.o$','\.d$','^node_modules$', '^coverage$']
nnoremap <silent> <F2> :NERDTreeToggle<CR>
nnoremap <silent> <F4> :NERDTreeFind<CR>

" Airline tabline
"let g:airline_powerline_fonts = 1 " Too much effort to patch fonts on all machines
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='wombat'
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" Startify
let g:startify_change_to_vcs_root = 1
let g:startify_session_persistence = 0		" automatically update sessions
let g:startify_show_sessions = 1
nnoremap <F1> :Startify<cr>

" Pandoc
let g:pandoc#modules#disabled = ["folding"]
let g:pandoc#formatting#smart_autoformat_on_cursormoved = 1
let g:pandoc#syntax#codeblocks#embeds#langs = ["ruby","python",
                \ "literatehaskell=lhaskell", "bash=sh","json=javascript",
                \ "css","html","javascript","c","cpp","make", "asm", "java"]
let g:pandoc#syntax#conceal#blacklist = ["list","atx"]

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_javascript_checkers=['jshint']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
function! ToggleErrors()
    let old_last_winnr = winnr('$')
    lclose
    if old_last_winnr == winnr('$')
        SyntasticCheck
        Errors
    endif
endfunction

nnoremap <silent> <C-e> :<C-u>call ToggleErrors()<CR>

" Tagbar stuff
map <silent> <F3> :TagbarToggle<CR>
let g:tagbar_autofocus = 1
let g:tagbar_compact = 1

" Git
nnoremap <silent> <leader>ga :Git add %:p<CR><CR>
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gc :Gcommit -v -q<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gl :Glog<CR>

" Colorscheme
noremap <PageUp> :PrevColorScheme<CR>
noremap <PageDown> :NextColorScheme<CR>

let g:rainbow_active = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable                  " Enable syntax highlighting

set wildmenu                   " Expands autocompletion stuff in cmd mode
set wildignore=*.o,*~,*.pyc    " Ignore compiled files

set ruler                      " Show cursor position
set cmdheight=1                " Lines to use for cmd line

set backspace=eol,start,indent " Backspaces solos everything
set whichwrap+=<,>,h,l         " move to next line after line end

set ignorecase                 " ignore case when searching
set smartcase                  " case-sensitive if uppercase search
set hlsearch                   " Highlight search results
set incsearch                  " Show search matches as you type
set magic                      " Regex is love regex is life
set showmatch                  " Show matching brackets when text indicator is over them
set matchtime=2                " Time limit for matching brackets
set lazyredraw                 " less is more
set noshowmode                 " don't show current mode
set nowrap                     " don't wrap lines
set number                     " Line numbers
set cursorline                 " Highlight cursor line

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
    let g:ag_working_path_mode="r"
    nnoremap <leader>fw :execute "Ag ".expand("<cword>")<CR>
    nnoremap <leader>ff :Ag<space>
    set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
    set grepformat=%f:%l:%c:%m
endif

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Unhighlight search results
nnoremap <silent> <BS> :set hlsearch! hlsearch?<cr>

" Swap between header and implementation file
nnoremap <F6> :e %:p:s,.h$,.X123X,:s,.cc$,.h,:s,.X123X$,.cc,<CR>

" Quick access to config files. TODO: May need to remap
nmap <leader>, :e ~/.vim/vimrc<CR>
nmap <leader>. :e ~/.vim/sandbox.vim<CR>
nmap <leader>t :e ~/.tmux.conf<CR>

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
nnoremap <F12> mzgg=G`z

" TODO: Delete trailing white space on save
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

autocmd BufWrite *.py,*.md,*.js :call DeleteTrailingWS()

" Reselect paste
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Test panel
nnoremap <silent> <leader>j :sp<CR>:resize 10<CR> :execute 'edit' expand('%:r').'.in'<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => GUI
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Reduce annoying split line impact
set fillchars+=vert:.
hi! VertSplit ctermfg=234 ctermbg=234 term=NONE

" Indent guide configuration for terminal
if v:version > 703
    " TODO: Enable or disable on startup?
    "let g:indent_guides_enable_on_vim_startup = 1
    let g:indent_guides_auto_colors=0
    function! s:indent_set_console_colors()
        hi IndentGuidesOdd ctermbg=234 guibg=darkgrey
        hi IndentGuidesEven ctermbg=233 guibg=darkgrey
    endfunction
    autocmd VimEnter,Colorscheme * call s:indent_set_console_colors()
endif

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
    hi CursorLine term=bold cterm=bold guibg=#1c136f
    highlight Cursor guifg=black guibg=#65e770
    highlight iCursor guifg=black guibg=#65e770
    hi clear Conceal
elseif (&term =~ "xterm" || &term =~ "screen-256color" || &term =~ "rxvt-unicode-256color")
    "TODO: Check 256 color support first
    set t_Co=256
    "let g:airline_theme='tomorrow'
    "colorscheme Tomorrow

    colorscheme jellybeans
    hi CursorLine ctermbg=17
    hi clear Conceal
elseif !empty($CONEMUBUILD)
    set term=pcansi
    set t_Co=256
    set background=dark
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"
    set bs=indent,eol,start
    hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white
    colorscheme jellybeans
    highlight Cursor guifg=black
    highlight iCursor guifg=black
endif
