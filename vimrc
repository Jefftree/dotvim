set nocompatible
let s:is_windows = has('win32') || has('win64')

"Neocompl
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Leader to comma
let mapleader = ","
let g:mapleader = ","
let maplocalleader = "\\"
let g:localleader = "\\"

" Faster saving
nmap <leader>w :w!<cr>
set clipboard=unnamed " Share clipboard with windows

" Start vim split window
" au VimEnter * vsplit

"Markdown support
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

set timeoutlen=1000   " mapping timeout
set ttimeoutlen=50   " keycode timeout
set nofoldenable     " disable folding
set mouse=a          " enable mouse
set history=1000     " number of command lines to remember
set ttyfast          " assume fast terminal connection
set encoding=utf-8   " set encoding for text
set hidden           " allow buffer switching without saving
set autoread         " auto reload if file saved externally
set showcmd          " always show last used command
set autochdir        " automatically change to file dir

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
NeoBundle 'airblade/vim-gitgutter'          " Gitgutter
NeoBundle 'luochen1990/rainbow'             " double rainbow
NeoBundle 'mhinz/vim-startify'              " More useful startup page
NeoBundle 'xolox/vim-colorscheme-switcher', {
            \ 'depends' : 'xolox/vim-misc'}  " Quickswitch theme

" Functionality
NeoBundle 'kien/ctrlp.vim'                  " File searcher
NeoBundle 'godlygeek/tabular'               " Easy alignment of variables
NeoBundle 'scrooloose/nerdtree'             " File explorer
NeoBundle 'tpope/vim-fugitive'              " Git
NeoBundle 'Raimondi/delimitMate'            " Matching parentheses
NeoBundle 'nathanaelkane/vim-indent-guides' " Indent visuals
NeoBundle 'tpope/vim-speeddating'           " <C-a>, <C-x> for dates
NeoBundle 'tpope/vim-surround'              " Surround shortcuts
NeoBundle 'scrooloose/syntastic'            " Syntax errors
NeoBundle 'majutsushi/tagbar'               " Tag browsing
NeoBundle 'scrooloose/nerdcommenter'        " Commenting shortcuts
NeoBundle 'rking/ag.vim'                    " Searcher
NeoBundle 'qpkorr/vim-bufkill'              " Close buffer without closing window
NeoBundle 'mbbill/undotree'                 " Undo tree

" Language specific
NeoBundle 'derekwyatt/vim-scala'            " Scala support
NeoBundle 'tpope/vim-markdown'              " Markdown support
NeoBundle 'jelera/vim-javascript-syntax'    " Javascript Highlighting
NeoBundle 'vim-pandoc/vim-pandoc'           " Pandoc
NeoBundle 'vim-pandoc/vim-pandoc-syntax'    " Pandoc Syntax
NeoBundle 'elzr/vim-json'                   " JSON Highlighting

NeoBundleLazy 'gregsexton/gitv', {'depends':['tpope/vim-fugitive'], 'autoload':{'commands':'Gitv'}} "{{{
    nnoremap <silent> <leader>gv :Gitv<CR>
    nnoremap <silent> <leader>gV :Gitv!<CR>
"}}}

NeoBundleLazy 'Shougo/neocomplcache.vim', {'autoload':{'insert':1}} "{{{

" Auto open new line w indentation after {<cr>
inoremap {<CR> {<CR>}<Esc>ko

let g:neocomplcache_enable_at_startup=1
let g:neocomplcache_enable_fuzzy_completion=1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_min_syntax_length = 2

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()

function! s:my_cr_function()
  "return neocomplcache#smart_close_popup() . "\<CR>"
  return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction

inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

if !exists('g:neocomplcache_force_omni_patterns')
  let g:neocomplcache_force_omni_patterns = {}
endif

call neobundle#end()
filetype plugin indent on
NeoBundleCheck " Check for missing plugins on startup

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <F5> :UndotreeToggle<CR>

" Tabularize shortcut
if exists("Tabularize")
    map <Leader>a= :Tabularize /=<CR>
    map <Leader>a: :Tabularize /:<CR>
    map <Leader>a" :Tabularize /"<CR>
endif

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

" NERDtree file explorer
let NERDTreeQuitOnOpen=0
let NERDTreeIgnore=['\.git','\.hg']
nnoremap <silent> <F2> :NERDTreeToggle<CR>
nnoremap <silent> <F4> :NERDTreeFind<CR>
let NERDTreeIgnore=['^node_modules$', '^coverage$']

" Airline tabline
"let g:airline_powerline_fonts = 1 " Too much effort to patch fonts on all machines
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='wombat'
let g:airline#extensions#tabline#buffer_idx_mode = 1	" display numbers in the tab line, and use mappings <leader>1 to <leader>9
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9

" startify
let g:startify_change_to_vcs_root = 1
let g:startify_session_persistence = 0		" automatically update sessions
let g:startify_show_sessions = 1
nnoremap <F1> :Startify<cr>

" pandoc
let g:pandoc#modules#disabled = ["folding"]
let g:pandoc#formatting#smart_autoformat_on_cursormoved = 1
let g:pandoc#syntax#codeblocks#embeds#langs = ["ruby", "scala",
                \ "literatehaskell=lhaskell", "bash=sh","json=javascript",
                \ "css","html","javascript","c","cpp"]
let g:pandoc#syntax#conceal#blacklist = ["list","atx"]

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_javascript_checkers=['jscs']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
function! ToggleErrors()
    let old_last_winnr = winnr('$')
    lclose
    if old_last_winnr == winnr('$')
        SyntasticCheck
        " Nothing was closed, open syntastic error location panel
        Errors
    endif
endfunction

nnoremap <silent> <C-e> :<C-u>call ToggleErrors()<CR>

" Tagbar stuff
map <silent> <F3> :TagbarToggle<CR>
let g:tagbar_autofocus = 1
let g:tagbar_compact = 1

" Git
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gl :Glog<CR>

" Colorscheme
noremap <PageUp> :PrevColorScheme<CR>
noremap <PageDown> :NextColorScheme<CR>


  " Highlight TODO, FIXME, NOTE, etc.
autocmd ColorScheme * highlight TodoRed      guifg=#FF5F5F gui=bold
autocmd ColorScheme * highlight NoteOrange   guifg=LightGreen gui=bold

let g:rainbow_active = 1 " auto activate double rainbow

if v:version > 703
    let g:indent_guides_enable_on_vim_startup = 1
    hi IndentGuideOdd guibg=darkgrey ctermbg=236
    hi IndentGuideEven guibg=darkgrey ctermbg=237
    if !has('gui_running')
        let g:indent_guides_auto_colors=0
        function! s:indent_set_console_colors()
            hi IndentGuidesOdd ctermbg=235
            hi IndentGuidesEven ctermbg=236
        endfunction
        autocmd VimEnter,Colorscheme * call s:indent_set_console_colors()
    endif
endif
augroup HiglightTODO
    autocmd!
    autocmd WinEnter,VimEnter * :silent! call matchadd('TodoRed', '\v[^a-zA-Z]TODO(:)?', -1)
    autocmd WinEnter,VimEnter * :silent! call matchadd('NoteOrange', 'NOTE', -1)
    autocmd WinEnter,VimEnter * :silent! call matchadd('Todo', 'INFO', -1)
    autocmd WinEnter,VimEnter * :silent! call matchadd('Todo', 'IDEA', -1)
    autocmd WinEnter,VimEnter * :silent! call matchadd('Todo', 'BUG', -1)
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => UI/UX
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable

if v:version > 703
    "set colorcolumn=80
endif

set wildmenu " Wild menu expands autocompletion stuff in cmd mode for tab navigation
set wildignore=*.o,*~,*.pyc " Ignore compiled files

set ruler       "Show cursor position
set cmdheight=1 " Lines to use for cmd line

set backspace=eol,start,indent " Backspaces solos everything
" set whichwrap+=<,>,h,l

" TODO: Must be a better way to do this. Unhighlight search results
nnoremap <silent> <BS> :set hlsearch! hlsearch?<cr>

set ignorecase  " ignore case when searching
set smartcase   " case-sensitive if uppercase search
set hlsearch    " Highlight search results
set incsearch   " Show search matches as you type
set magic       " Regex is love regex is life
set showmatch   " Show matching brackets when text indicator is over them
set matchtime=2 " Time limit for matching brackets
set lazyredraw
set noshowmode  " don't show current mode
set nowrap      " don't wrap lines

set number      " Line numbers
set cursorline  " Highlight cursor line

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

set shortmess+=I "No annoying startup message
set scrolloff=10 " Don't let cursor be near vertical edge of screen

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off
set nobackup
set nowb
set noswapfile

" Undotree
if has("persistent_undo")
    set undodir=~/.vim/.undodir
    set undofile
    set undolevels=1000 "maximum number of changes that can be undone
    set undoreload=10000 "maximum number lines to save for undo on a buffer reload
endif

" Quick access to vimrc
nmap <leader>, :e ~/.vim/vimrc<CR>

" Apply vimrc changes without restart
nmap <silent> <leader>r :so $MYVIMRC<CR>

" Start in desired directory
cd W:/

" Easy buffer navigation using tabs
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

"Close buffer
nnoremap Q :bd<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab    " Use spaces instead of tabs
set smarttab     " insert tabs according to shiftwidth, not tabstop

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
set shiftround   " use multiple of shiftwidth when indenting with '<' and '>'

set autoindent   " always set autoindenting on
set copyindent   " copy the previous indentation on autoindenting

if executable('ag')
    nnoremap <Leader>fw :execute "Ag ".expand("<cword")<CR>
    nnoremap <Leader>ff :Ag
    set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
    set grepformat=%f:%l:%c:%m
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Splitting shortcuts and defaults
set splitright
set splitbelow
nnoremap <Leader>s :sp<CR>
nnoremap <Leader>v :vsp<CR>

vmap <Leader>s :sort<CR>
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
""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Remap VIM 0 to first non-blank character
nnoremap 0 ^
nnoremap ^ 0

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv


" TODO: Delete trailing white space on save
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.js :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

if has('gui_running')
    colorscheme jellybeans
    "colorscheme herald
    set guifont=Inconsolata\ for\ Powerline:h14
    "set guifont=Inconsolata:h11:cANSI
    au GUIEnter * simalt ~x
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
elseif !empty($CONEMUBUILD)
    set term=pcansi
    set t_Co=256
    set background=dark " Does this stuff work?
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"
    set bs=indent,eol,start
    " Dark scheme, only for terminal
    hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white
    "hi CursorLine term=bold cterm=bold
    highlight Cursor guifg=black
    highlight iCursor guifg=black
    colorscheme hybrid
elseif &term =~ "xterm"
    let &t_Co = 256
    " restore screen after quitting
    let &t_ti = "\<Esc>7\<Esc>[r\<Esc>[?47h"
    let &t_te = "\<Esc>[?47l\<Esc>8"
    if has("terminfo")
        let &t_Sf = "\<Esc>[3%p1%dm"
        let &t_Sb = "\<Esc>[4%p1%dm"
    else
        let &t_Sf = "\<Esc>[3%dm"
        let &t_Sb = "\<Esc>[4%dm"
    endif
    colorscheme jellybeans
endif
