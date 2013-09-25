set fileencoding=utf8

"set spell

" indenting and line length
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" folding
syn region myFold start="{" end="}" transparent fold
syn sync fromstart
set foldmethod=indent
"set foldmethod=syntax

" php neatness
let php_folding=1
let php_sql_query=1
let php_htmlInStrings=1

" make make work
set makeprg=php\ -l\ %
set errorformat=%m\ in\ %f\ on\ line\ %l

" syntax on
"
