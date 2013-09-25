" folding
"syn region myFold start="{" end="}" transparent fold
"syn sync fromstart
set foldmethod=syntax

" indent
set fo=tcrqn		" See Help (complex)
set textwidth=80	" text width
set ai			" autoindent
set si			" smartindent 
set cindent		" do c-style indenting
set tabstop=8		" tab spacing (settings below are just to unify it)
set softtabstop=8	" unify
set shiftwidth=8	" unify 
"set noexpandtab		" real tabs please!
"set nowrap		" do not wrap lines  
"set smarttab		" use tabs at the start of a line, spaces elsewhere

" http://vimdoc.sourceforge.net/htmldoc/windows.html#CursorHold-example
"au! CursorHold *.[ch] nested call PreviewWord()
"func PreviewWord()
"  if &previewwindow			" don't do this in the preview window
"    return
"  endif
"  let w = expand("<cword>")		" get the word under cursor
"  if w =~ '\a'			" if the word contains a letter
"
"    " Delete any existing highlight before showing another tag
"    silent! wincmd P			" jump to preview window
"    if &previewwindow			" if we really get there...
"      match none			" delete existing highlight
"      wincmd p			" back to old window
"    endif
"
"    " Try displaying a matching tag for the word under the cursor
"    try
"       exe "ptag " . w
"    catch
"      return
"    endtry
"
"    silent! wincmd P			" jump to preview window
"    if &previewwindow		" if we really get there...
"	 if has("folding")
"	   silent! .foldopen		" don't want a closed fold
"	 endif
"	 call search("$", "b")		" to end of previous line
"	 let w = substitute(w, '\\', '\\\\', "")
"	 call search('\<\V' . w . '\>')	" position cursor on match
"	 " Add a match highlight to the word at this position
"      hi previewWord term=bold ctermbg=green guibg=green
"	 exe 'match previewWord "\%' . line(".") . 'l\%' . col(".") . 'c\k*"'
"      wincmd p			" back to old window
"    endif
"  endif
"endfun

