if !exists(':Tabularize')
  finish " Tabular.vim wasn't loaded
endif

" only first '=', but not '=>' and '=='
AddTabularPattern =  /^[^=]*\zs=\(>\|=\)\@!
" only first ':', no space before it
AddTabularPattern :  /^[^:]*\zs:\zs
AddTabularPattern => /=>
