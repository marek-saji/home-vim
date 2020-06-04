" vim: shiftwidth=4 tabstop=4 expandtab

if &encoding == 'utf-8'
    let g:errorSign = '‼️ '
    let g:warnSign = '⚠️ '
    let g:infoSign = 'ℹ '
    let g:hintSign = '💡'
else
    let g:errorSign = 'E'
    let g:warnSign = 'W'
    let g:infoSign = 'I'
    let g:hintSign = 'i'
endif

" be (vi)improved
set nocompatible

" history lines to remember
set history=4096

" line numbers
set number

" allow hidden, unsaved buffers
set hidden

" always show sign column
set signcolumn=yes

" more lines for messages
set cmdheight=2

" always show status line
set laststatus=2

set list listchars=tab:⇒·,trail:◦,nbsp:•,extends:▻

" transparent signcolumn
highlight clear SignColumn
" highlight current line number in black
"highlight CursorLineNr ctermbg=black guibg=black
set cursorline

" don’t wrap long lines
set nowrap

" shortens messages to avoid 'press a key' prompt
set shortmess=atI

" keep active line the middle of the screen
set scrolloff=999

" highlight searched for phrases
set hlsearch
" highlight search as you type
set incsearch

" remove comment prefix when joining lines
set formatoptions+=j
" don’t break lines that are already long
set formatoptions+=l
" continue comment after hitting enter in comment
set formatoptions+=r

set autoindent
set smartindent

set expandtab
set shiftwidth=4
set tabstop=4

set textwidth=72

" ask instead of failing
set confirm

" Use system clipboard
if has("clipboard")
  " PRIMARY (select/middle mouse button)
  set clipboard=unnamed
elseif has("unnamedplus")
  " CLIPBOARD (Ctrl-C/Ctrl-V)
  set clipboard=unnamedplus
endif

" use mouse everywhere
set mouse=a
" source: comment in http://unix.stackexchange.com/a/50735
set ttymouse=xterm2

" Load ftplugins
filetype plugin on

" auto open quickfix window
autocmd QuickFixCmdPost *grep* cwindow
autocmd QuickFixCmdPost *log* cwindow
" Adjust quickfix window height to content
" https://gist.github.com/juanpabloaj/5845848
au FileType qf call AdjustWindowHeight(2, 10)
function! AdjustWindowHeight(minheight, maxheight)
    let l = 1
    let n_lines = 0
    let w_width = winwidth(0)
    while l <= line('$')
        " number to float for division
        let l_len = strlen(getline(l)) + 0.0
        let line_width = l_len/w_width
        let n_lines += float2nr(ceil(line_width))
        let l += 1
    endw
    exe max([min([n_lines, a:maxheight]), a:minheight]) . "wincmd _"
endfunction

" Files / Backups
silent !mkdir -p ~/.cache/vim/{backup,temp}
set backup
set backupdir=~/.cache/vim/backup
set directory=~/.cache/vim/temp
set makeef=error.err

" Move cursor to next/prev line with →/←
set whichwrap+=<,>

" prev/next tab  with C-left/right
map [1;5C <esc>:tabn<CR>
map [1;5D <esc>:tabp<CR>

" fat fingers, yo
command Q q
command Qa qa
command QA qa
command W w
command Wq wq
command WQ wq
command Bd bd

" Create directory, when saving a file
" source: http://stackoverflow.com/a/4294176
function s:MkNonExDir(file, buf)
  if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
    let dir=fnamemodify(a:file, ':h')
    if !isdirectory(dir)
      call mkdir(dir, 'p')
    endif
  endif
endfunction
augroup BWCCreateDir
  autocmd!
  autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

" Status line

function! LinterStatus() abort
    return coc#status()
endfunction

function! GitStatus() abort
    return fugitive#statusline()
endfunction

set statusline=%<%f\ %h%m%r\ %{LinterStatus()}%=\ %{GitStatus()}\ %-14.(%l,%c%V%)\ %P



" Plugins stuff

" Change default command to omit more files
command! -bang -nargs=? -complete=dir
  \ Files call fzf#vim#files(<q-args>, {
    \ 'source': "find . -mindepth 1 \\( -type d \\( -name '.*' -or -name node_modules -or -name npm-packages-offline-cache -or -name dist -or -path './coverage/lcov-report/*' \\) -prune \\) -or -type f -print"
  \ }, <bang>0)
" fzf: Map Ctrl-P
noremap <c-p> :Files<CR>
" fzf: keep history
let g:fzf_history_dir = '~/.cache/fzf.vim_history'

" gitgutter: jumping around
nmap [h <Plug>(GitGutterPrevHunk)
nmap ]h <Plug>(GitGutterNextHunk)
" gitgutter: staging
nmap <Leader>hs <Plug>(GitGutterStageHunk)
nmap <Leader>hr <Plug>(GitGutterRevertHunk)

" coc
let g:coc_status_error_sign = g:errorSign
let g:coc_status_warning_sign = g:warnSign

augroup TODO
    function TodoBufRead ()
        " Show less UI
        setlocal cmdheight=1 noshowcmd laststatus=0 nonumber signcolumn=no spell
        " Restore previous position (if valid)
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
        endif
    endfunction
    autocmd BufRead TODO{,.md,.markdown,.txt} call TodoBufRead()
augroup end

augroup bashfc
    autocmd BufRead /tmp/bash-fc.* setlocal wrap
augroup end

augroup coc-settings
    autocmd BufRead coc-settings.json syntax match Comment +\/\/.\+$+
augroup end
