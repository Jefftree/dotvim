
" Utilities
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build': {
        \ 'mac': 'make -f make_mac.mak',
        \ 'unix': 'make -f make_unix.mak',
        \ 'cygwin': 'make -f make_cygwin.mak',
        \ 'windows': 'mingw32-make -f make_mingw32.mak',
      \ },
    \ }

"}}}

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





" Snippets from vimrc that aren't being used
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



