" VIM configuration
"
" Licensed under MIT, see LICENSE file
"
" vim: filetype=vim expandtab softtabstop=2 tabstop=2

" be (VI)iMproved
set nocompatible

" UTF-8, anyone?
if has("multi_byte")
  if &termencoding == ""
    let &termencoding=&encoding
    if $TERM == "linux" || $TERM_PROGRAM == "GLterm"
      let &termencoding="latin1"
    elseif $TERM == "xterm" || $TERM == "xterm-color"
      let propv = system("xprop -id $WINDOWID -f WM_LOCALE_NAME 8s ' $0' -notype WM_LOCALE_NAME")
      if propv !~ "WM_LOCALE_NAME .*UTF.*8"
        let &termencoding="latin1"
      endif
    endif
  endif
  " use utf-8 internally
  set encoding=utf-8
  " change default file encoding when writing new files
  setglobal fileencoding=utf-8
endif


" Use vundle to handle plugins
" https://github.com/gmarik/vundle

" re-enabled at the end of the file
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
Bundle 'gmarik/vundle'

Bundle 'skammer/vim-css-color'
Bundle 'groenewege/vim-less'
Bundle 'tpope/vim-surround'
Bundle 'scrooloose/syntastic'
" Bundle 'marijnh/tern_for_vim'
Bundle 'editorconfig/editorconfig-vim'
Bundle 'mattn/webapi-vim'
Bundle 'tomtom/tcomment_vim'
Bundle "digitaltoad/vim-jade"
Bundle "camelcasemotion"

Bundle 'mattn/gist-vim'
let g:gist_get_multiplefile = 1

Bundle 'airblade/vim-gitgutter'
nmap [h <Plug>GitGutterPrevHunk
nmap ]h <Plug>GitGutterNextHunk
nmap <Leader>hs <Plug>GitGutterStageHunk
nmap <Leader>hr <Plug>GitGutterRevertHunk

Bundle 'godlygeek/tabular'
" configuration in ~/.vim/after/plugin/TabularMaps.vim


Bundle 'grep.vim'
let Grep_Skip_Dirs = "RCS CVS SCCS .svn .git"
let Grep_Skip_Files = "tags tags-*"


Bundle 'msanders/snipmate.vim'
let g:snips_author = 'Marek Augustynowicz'


Bundle 'tpope/vim-fugitive'
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
" auto open quickfix window
autocmd QuickFixCmdPost *grep* cwindow
autocmd QuickFixCmdPost *log* cwindow


Bundle 'sjl/gundo.vim'
nnoremap <C-z> :GundoToggle<CR>


Bundle 'joonty/vdebug'
let g:vdebug_options = {}
" don't break, when connection is made
let g:vdebug_options['break_on_open'] = 0
let g:vdebug_options['port'] = 9001


Bundle 'kien/ctrlp.vim'
let g:ctrlp_prompt_mappings = {
    \ 'PrtSelectMove("t")':   [],
    \ 'PrtSelectMove("b")':   [],
    \ 'PrtCurStart()':        ['<Home>', '<kHome>'],
    \ 'PrtCurEnd()':          ['<End>', '<kEnd>'],
  \ }
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_extensions = ['tag',  'mixed']
" only MRU files in the current working directory
let g:ctrlp_mruf_relative = 1
" use current working directory
let g:ctrlp_working_path_mode = '0'
" let g:ctrlp_max_depth = 32
" let g:ctrlp_max_files = 65536
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|node_modules|cache|DoctrineORMModule\/Proxy|vendor\/.*\/tests?)$',
  \ 'file': '\v\.(so|zip|doc|xls|pdf|png|gif|jpe?g|gz)$'
\ }
noremap <c-o> :CtrlPTag<CR>




" don't use tabs at begining of the line
set nosmarttab
" don't show options, when tab-completing
" (doesn't play well with CtrlP plugin)
set nowildmenu
" history lines to remember
set history=1000
" ask instead of failing
set confirm
" support all, in this order
set fileformats=unix,dos,mac
" make sure it can save viminfo
set viminfo+=!
" none ot thes should be word dividers
set iskeyword+=_,$,@,%,#,-

if has("clipboard")
  set clipboard=unnamed
elseif has("xterm_clipboard") && has("unnamedplus")
  set clipboard=unnamedplus
endif


" Files / Backups

silent !mkdir -p ~/.cache/vim/{backup,temp}
set backup
set backupdir=~/.cache/vim/backup
set directory=~/.cache/vim/temp
set makeef=error.err


"
" vim UI
"

" command bar height
set cmdheight=1
" show line numbers
set number
" allow hidden, unsaved buffers
set hidden
" make backspace act flexible
set backspace=indent,eol,start
" backspace and cursor keys wrap
set whichwrap+=<,>,h,l
" use mouse everywhere
set mouse=a
" shortens messages to avoid 'press a key' prompt
set shortmess=atI

set textwidth=72
" don't break already long lines
set formatoptions+=l
" relative to textwidth
set colorcolumn=+0
" highlight column at textwidth
highlight clear ColorColumn
highlight ColorColumn cterm=underline
" hightlight characters above textwidth
highlight clear OverLength
highlight OverLength cterm=bold
execute 'match OverLength /\%'.&textwidth.'v.*/'
" colors for GUI set in .gvimrc

" hightlight current line in black
highlight clear CursorLine
highlight CursorLine ctermbg=black
set cursorline

" always show gutter (sign column)
autocmd BufEnter * sign define empty
autocmd BufEnter * execute 'sign place 9999 line=1 name=empty buffer=' . bufnr('')
" and make it trasparent
highlight SignColumn ctermbg=none

" show matching brackets
set showmatch
" highlight searched for phrases
set hlsearch
" highlight as you type you search phrase
set incsearch

" list tabs and trailing spaces
if (&termencoding == "utf-8")
  set list listchars=tab:⇒·,trail:◦,nbsp:•,extends:▻
else
  set list listchars=tab:>-,trail:.,nbsp:_,extends:>
endif


"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
"set statusline=%F%m%r%h%w\ [%{&ff},%Y]\ [%l,%v\ %p%%]\ [LEN=%L]


"
" text formatting / layout
"

set formatoptions=tcrqn
" Use the 'j' format option when available.
if v:version ># 703 || v:version ==# 703 && has('patch541')
    set formatoptions+=j
endif
set autoindent
set smartindent
set cindent
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab

" auto-close curly brackets
" Try out Raimondi/delimitMate if that's not enough
inoremap {<CR>  {<CR>}<Esc>O
inoremap {<CR>} {<CR>}


"
" folding
"

set foldenable
" Make folding indent sensitive
"set foldmethod=syntax
set foldmethod=indent
"set foldcolumn=2
"" Don't autofold anything (but I can still fold manually)
set foldlevel=100
" don't open folds when you search into them
set foldopen-=search
" don't open folds when you undo in them
set foldopen-=undo


"
" spelling
"

set spelllang=pl,en
highlight clear SpellBad
highlight SpellBad ctermbg=red ctermfg=white


" correct common typos
command Q q
command Qa qa
command QA qa
command W w
command Wq wq
command WQ wq

"map <A-v> viw"+gPb
"map <A-c> viw"+y
"map <A-x> viw"+x

" prev/next tab  with C-left/right
map [1;5C <esc>:tabn<CR>
map [1;5D <esc>:tabp<CR>
" prev/next buffer with C-down/up
"map [1;5B <esc>:bn<CR>	" C-down
"map [1;5A <esc>:bp<CR>	" C-up



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


" term and screen titles
if has("statusline") && has("title")
  if &term =~ 'screen\(\.\(xterm\|rxvt\)\(-\(256\)\?color\)\?\)\?'
    " term title.
    set t_ts=]2;
    set t_fs=
    set title
    set titlestring=vim\ :\ %t%(\ %M%)%(\ %{fugitive#statusline()}%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)
    " screen title
    set t_IS=k
    set t_IE=\
    set icon
    set iconstring=vim\ %t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)
  else
    " term title
    set title
    set titlestring=vim\ —\ %t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)
  endif
endif


" turn on after it was turned off for Vundle
" Turns on filetype detection, filetype plugins, and filetype indenting
filetype plugin indent on

" Turns on filetype detection if not already on,
" and then applies filetype-specific highlighting.
syntax enable
