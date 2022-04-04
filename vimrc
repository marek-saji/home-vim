" vim: shiftwidth=4 tabstop=4 expandtab

" Show config problems. Will be permanently showin in statusline
let warnings=[]

if &encoding == 'utf-8'
    let g:errorSign = '🔥'
    let g:warnSign = '⚠️ '
    let g:infoSign = '🛈 '
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

" British
set spelllang=en_gb,en,pl

" allow hidden, unsaved buffers
set hidden

" terminals should be dark
set bg=dark

" always show sign column
set signcolumn=yes

" more lines for messages
set cmdheight=2

" always show status line
set laststatus=2

set list
if &encoding == 'utf-8'
    set listchars=tab:⇒·,trail:◦,nbsp:•,extends:▻
endif

" GUI: select font
set guifont=JetBrains\ Mono\ Regular\ 12
" GUI: hide toolbar and menubar
set guioptions-=T
set guioptions-=m

" highlight searched for phrases
set hlsearch
" highlight search as you type
set incsearch

colorscheme default
" dark
set background=dark
highlight Normal guifg=white guibg=black

" transparent sign column
highlight clear SignColumn
" highlight current line
set cursorline
highlight CursorLineNr cterm=none ctermbg=black
highlight CursorLine cterm=none ctermbg=black
" more strict styling of TODO to avoid unreadable text
highlight Todo cterm=reverse ctermfg=yellow ctermbg=black

" wrap long lines
set wrap

" shortens messages to avoid 'press a key' prompt
set shortmess=atI

" keep active line the middle of the screen
set scrolloff=999

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
else
 let warnings+=["no clipboard"]
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
silent !mkdir -p ~/.cache/vim/{backup,temp,undo}
set backup
set backupdir=~/.cache/vim/backup
set directory=~/.cache/vim/temp
set makeef=error.err
set undodir=~/.cache/vim/undo
set undofile

" Move cursor to next/prev line with →/←
set whichwrap+=<,>

" prev/next tab with C-left/right
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

set statusline=%<%f\ %h%m%r\ %{LinterStatus()}%=%{join(warnings,',\ ')}\ %{GitStatus()}\ %l,%c%V\ %P



" Plug–ins stuff

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

" coc: Stop nagging about upgrading vim
let g:coc_disable_startup_warning = 1

" coc: Don’t use nvm overwrites
let g:coc_node_path = '/usr/bin/node'

let g:coc_global_extensions = [
    \ 'coc-css',
    \ 'coc-diagnostic',
    \ 'coc-eslint',
    \ 'coc-html',
    \ 'coc-json',
    \ 'coc-markdownlint',
    \ 'coc-stylelintplus',
    \ 'coc-svg',
    \ 'coc-tsserver',
    \ 'coc-yaml',
\ ]
if has('nvim')
    let g:coc_global_extensions = g:coc_global_extensions + [
        \ 'coc-import-cost',
    \ ]
endif

" coc: Custom signs
let g:coc_status_error_sign = g:errorSign
let g:coc_status_warning_sign = g:warnSign

" coc: Jump to definition
if exists('&tagfunc')
    set tagfunc=CocTagFunc
else
    " for older versions of vim, remap Ctrl-], but Ctrl-t will not work
    noremap <c-]> :call CocActionAsync('jumpDefinition')<CR>
endif

augroup TODO
    function TodoBufRead ()
        " Show less UI
        setlocal noshowcmd laststatus=0 nonumber signcolumn=no spell
        " Enable folding
        setlocal foldmethod=indent foldlevel=999
        " Restore previous position (if valid)
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
        endif
        " silent loadview " FIXME
    endfunction
    autocmd BufRead TODO{,.md,.markdown,.txt} call TodoBufRead()
    " Save view (restored in TodoBufRead)
    autocmd BufWinLeave TODO{,.md,.markdown,.txt} silent mkview
augroup end

augroup jest-snapsots
    autocmd BufRead *.js.snap setlocal ft=javascript
    autocmd BufRead *.ts.snap setlocal ft=typescript
    autocmd BufRead *.storyshot setlocal ft=javascript
augroup end

augroup rc-json
    autocmd BufRead .eslintrc setlocal ft=json
augroup end

augroup bashfc
    autocmd BufRead /tmp/bash-fc.* setlocal wrap
augroup end

augroup jira
    autocmd BufRead jira setlocal ft=confluencewiki spell wrap
augroup end

augroup dot-env
    autocmd BufRead .env{,.*} setlocal ft=dotenv syntax=sh commentstring=#\ %s
    " FIXME Would be much better to use ft=sh but add -e SC2148,SC2034 to shellcheck linter in coc
augroup end

" FIXME This is not working:
" augroup mdx
"     autocmd FileType unlet b:current_syntax | runtime syntax/typescriptreact.vim | let b:current_syntax='mdx'
" augroup end
