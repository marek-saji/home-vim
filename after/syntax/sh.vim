set fileencoding=utf8

" indenting and line length
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" hightlight 81th column in black
"set colorcolumn=80
"highlight ColorColumn ctermbg=black guibg=gray13

" hightlight 81th character in red
"highlight OverLength ctermbg=black guibg=gray13
highlight OverLength ctermbg=red guibg=red
match OverLength /\%81v./


