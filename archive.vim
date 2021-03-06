" ======================================================
" Stuff that looks interesting, but never ended up using
" ======================================================

if has("gui_macvim")
    let macvim_hig_shift_movement = 1 " Shift to select text
    " What is this sorcery?
    nmap <SwipeLeft> :bprevious<CR>
    nmap <SwipeRight> :bnext<CR>
endif

call dein#add('nathanaelkane/vim-indent-guides') " Indent visuals

call dein#add('christoomey/vim-tmux-navigator')  " easier tmux navigation
call dein#add('jceb/vim-orgmode')                " Might be useful

NeoBundle 'xolox/vim-colorscheme-switcher', {
            \ 'depends' : 'xolox/vim-misc'}  " Quickswitch theme

" Colorscheme
noremap <PageUp> :PrevColorScheme<CR>
noremap <PageDown> :NextColorScheme<CR>

NeoBundle 'tpope/vim-speeddating'           " <C-a>, <C-x> for dates

NeoBundle 'derekwyatt/vim-scala'            " Scala support

" Don't use macvim anymore
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

" Snippets from vimrc that aren't being used

" Utilities
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build': {
        \ 'mac': 'make -f make_mac.mak',
        \ 'unix': 'make -f make_unix.mak',
        \ 'cygwin': 'make -f make_cygwin.mak',
        \ 'windows': 'mingw32-make -f make_mingw32.mak',
      \ },
    \ }

" Unite requires latest vim version
NeoBundle 'Shougo/unite.vim'                " UI for bunch of stuff
NeoBundleLazy 'Shougo/neomru.vim', {'autoload':{'unite_sources':'file_mru'}}

" Unite
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom#profile('default', 'context', {
              \ 'start_insert': 1,
              \ 'winheight': 8,
              \ 'direction': 'botright'
              \ })
let g:unite_source_history_yank_enable=1

if executable('ag')
    let g:unite_source_rec_async_command = 'ag --follow --nocolor --nogroup --hidden -g ""'
    let g:unite_source_grep_command='ag'
    let g:unite_source_grep_default_opts='--nocolor --line-numbers --nogroup -S -C4'
    let g:unite_source_grep_recursive_opt=''
endif

nmap <space> [unite]
nnoremap [unite] <nop>

"if exists('b:git_dir')

nnoremap <silent> [unite]f :<C-u>Unite -buffer-name=Search -input= file_rec/async:!<cr>
    "<c-u> means cursor up one line
nnoremap <silent> [unite]<space> :<C-u>Unite -toggle -auto-resize -buffer-name=mixed file_rec/async:! buffer file_mru bookmark<cr><c-u>


call dein#add('scrooloose/syntastic')            " Syntax errors

" Syntastic
let g:syntastic_enable_racket_racket_checker = 1
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_javascript_checkers=['eslint']
let g:syntastic_python_checkers=['pyflakes']
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


call dein#add('luochen1990/rainbow')             " double rainbow
let g:rainbow_active = 0

NeoBundle 'klen/python-mode'                " Python

" Python-mode
" Activate rope
" Keys
" K             Show python docs
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

if !empty($CONEMUBUILD)
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
