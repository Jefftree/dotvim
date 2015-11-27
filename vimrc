set nocompatible
set all& "reset
let s:is_windows = has('win32') || has('win64')

" Enable omni completion.
au FileType css setlocal omnifunc=csscomplete#CompleteCSS
au FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
au FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
au FileType python setlocal omnifunc=pythoncomplete#Complete
au FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("gui_macvim")
    let macvim_hig_shift_movement = 1 " Shift to select text
    " What is this sorcery?
    nmap <SwipeLeft> :bprevious<CR>
    nmap <SwipeRight> :bnext<CR>
endif

" Leader to comma
let mapleader = ","
let g:mapleader = ","
let maplocalleader = "\\"
let g:localleader = "\\"

" File extension corrections
au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
au BufNewFile,BufFilePre,BufRead *.*rc set filetype=vim

" makefile tab indent correction
au FileType make setlocal noexpandtab

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
set clipboard=unnamed " Share clipboard with windows

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
if has('lua')
    NeoBundle 'Shougo/neocomplete.vim'      " Completion
endif
NeoBundle 'Shougo/neosnippet'               " Snippets functionality
NeoBundle 'Shougo/neosnippet-snippets'      " Useful snippets
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
NeoBundle 'tpope/vim-repeat'                " Repeat stuff

" Language specific
NeoBundle 'jelera/vim-javascript-syntax'    " Javascript Highlighting
NeoBundle 'elzr/vim-json'                   " JSON Highlighting
NeoBundle 'mxw/vim-jsx'                     " JSX for React.js
NeoBundle 'derekwyatt/vim-scala'            " Scala support
NeoBundle 'tpope/vim-markdown'              " Markdown support
NeoBundle 'vim-pandoc/vim-pandoc'           " Pandoc
NeoBundle 'vim-pandoc/vim-pandoc-syntax'    " Pandoc Syntax
NeoBundle 'klen/python-mode'                " Python
NeoBundle 'tmux-plugins/vim-tmux'           " tmux file highlighting

NeoBundleLazy 'gregsexton/gitv', {'depends':['tpope/vim-fugitive'], 'autoload':{'commands':'Gitv'}} "{{{
    nnoremap <silent> <leader>gv :Gitv<CR>
    nnoremap <silent> <leader>gV :Gitv!<CR>
"}}}

let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets,~/.vim/snippets'
let g:neosnippet#enable_snipmate_compatibility=1

imap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ? "\<C-n>" : "\<TAB>")
smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
imap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""
smap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""

" ---------------- NEOCOMPLETE (Needs more tweaking)

if has('lua')
    " Disable AutoComplPop. (changed)
    let g:acp_enableAtStartup = 1
    " Use neocomplete.
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_smart_case = 1
    " Set minimum syntax keyword length.
    let g:neocomplete#sources#syntax#min_keyword_length = 3
    let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

    " Define dictionary.
    let g:neocomplete#sources#dictionary#dictionaries = {
        \ 'default' : '',
        \ 'vimshell' : $HOME.'/.vimshell_hist',
        \ 'scheme' : $HOME.'/.gosh_completions'
            \ }

    " Define keyword.
    if !exists('g:neocomplete#keyword_patterns')
        let g:neocomplete#keyword_patterns = {}
    endif
    let g:neocomplete#keyword_patterns['default'] = '\h\w*'

    " Plugin key-mappings.
    inoremap <expr><C-g>     neocomplete#undo_completion()
    inoremap <expr><C-l>     neocomplete#complete_common_string()

    " Recommended key-mappings.
    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
        return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
    " For no inserting <CR> key.
        "return pumvisible() ? "\<C-y>" : "\<CR>"
    endfunction
    " <TAB>: completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    " <C-h>, <BS>: close popup and delete backword char.
    inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    " Close popup by <Space>.
    "inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

    " AutoComplPop like behavior.
    let g:neocomplete#enable_auto_select = 0

    "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

    " Enable heavy omni completion.
    if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
    endif
    "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
    "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
    "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
endif

call neobundle#end()
filetype plugin indent on
NeoBundleCheck " Check for missing plugins on startup

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" JSX Enabled on all JS Files
let g:jsx_ext_required = 0

" Auto open new line indentation after {<cr>
inoremap {<CR> {<CR>}<Esc>ko

" Easily compile math notes
command Math Pandoc -s --mathjax
nnoremap <Leader>p :Math<CR>

" Xelatex compile
command Xelatex !xelatex %

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
                \ "css","html","javascript","c","cpp","python","make"]
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

" Python-mode
" Activate rope
" Keys
" K             Show python docs
" <Leader>r     Run program
" <Ctrl-Space>  Rope autocomplete
" <Ctrl-c>g     Rope goto definition
" <Ctrl-c>d     Rope show documentation
" <Ctrl-c>f     Rope find occurrences
" <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
" [[            Jump on previous class or function (normal, visual, operator modes)
" ]]            Jump on next class or function (normal, visual, operator modes)
" [M            Jump on previous class or method (normal, visual, operator modes)
" ]M            Jump on next class or method (normal, visual, operator modes)

let g:pymode_rope = 1
let g:pymode_run_bind = '<Space>r'

" Documentation
let g:pymode_doc = 1
let g:pymode_doc_key = 'K'

"Linting
let g:pymode_lint = 1
let g:pymode_lint_checkers = ["pyflakes"]
" Auto check on save
let g:pymode_lint_write = 1

" Support virtualenv
let g:pymode_virtualenv = 1

" Enable breakpoints plugin
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_bind = '<leader>b'

" syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" Don't autofold code
let g:pymode_folding = 0


let g:rainbow_active = 1 " auto activate double rainbow

" Indent guide configuration for terminal
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

" Highlight TODO, FIXME, NOTE, etc.
autocmd ColorScheme * highlight TodoRed      guifg=#FF5F5F gui=bold
autocmd ColorScheme * highlight NoteOrange   guifg=LightGreen gui=bold

" GUI TODO Highlighter
augroup HiglightTODO
    autocmd!
    autocmd WinEnter,VimEnter * :silent! call matchadd('TodoRed', '\v(^|[^a-zA-Z])TODO(:)?', -1)
    autocmd WinEnter,VimEnter * :silent! call matchadd('NoteOrange', 'NOTE', -1)
    autocmd WinEnter,VimEnter * :silent! call matchadd('Todo', 'IDEA', -1)
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable                  " Enable syntax highlighting

set wildmenu                   " Wild menu expands autocompletion stuff in cmd mode for tab navigation
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


" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

if has('autocmd')
  autocmd GUIEnter * set novisualbell t_vb=
endif


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


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off
set nobackup
set nowb
set noswapfile

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
    nnoremap <Leader>fw :execute "Ag ".expand("<cword>")<CR>
    nnoremap <Leader>ff :Ag<space>
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Unhighlight search results
nnoremap <silent> <BS> :set hlsearch! hlsearch?<cr>

" Quick access to vimrc
nmap <leader>, :e ~/.vim/vimrc<CR>

" Faster saving
nmap <leader>w :w!<cr>
nmap <leader>e :w !sudo tee %<cr>

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


" TODO: Delete trailing white space on save
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

autocmd BufWrite *.py,*.md,*.js :call DeleteTrailingWS()

nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

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
elseif &term =~ "xterm"
    "TODO: Check 256 color support first
    set t_Co=256
    colorscheme jellybeans
    hi CursorLine ctermbg=17
elseif !empty($CONEMUBUILD)
    set term=pcansi
    set t_Co=256
    set background=dark
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"
    set bs=indent,eol,start
    hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white
    highlight Cursor guifg=black
    highlight iCursor guifg=black
    colorscheme jellybeans
endif


" Make 
nnoremap <Leader>m :make debugrun<CR>
