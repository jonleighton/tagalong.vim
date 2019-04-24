" Initialize matchit, a requirement
if !exists('g:loaded_matchit')
  if has(':packadd')
    packadd matchit
  else
    runtime macros/matchit.vim
  endif
endif
if !exists('g:loaded_matchit')
  " then loading it somehow failed, we can't continue
  finish
endif

if exists('g:loaded_tagalong') || &cp
  finish
endif

let g:loaded_tagalong = '0.0.1' " version number
let s:keepcpo = &cpo
set cpo&vim

if !exists('g:tagalong_filetypes')
  let g:tagalong_filetypes = ['html', 'xml', 'jsx', 'eruby', 'ejs', 'eco', 'php', 'htmldjango']
endif

if !exists('g:tagalong_mappings')
  let g:tagalong_mappings = ['c', 'C', 'v', 'i', 'a']
endif

if !exists('g:tagalong_verbose')
  let g:tagalong_verbose = 0
endif

augroup tagalong
  autocmd!

  autocmd FileType * call s:InitIfSupportedFiletype(expand('<amatch>'))
augroup END

" Needed in order to handle dot-filetypes like "javascript.jsx" or
" "custom.html".
function! s:InitIfSupportedFiletype(filetype_string)
  for filetype in split(a:filetype_string, '\.')
    if index(g:tagalong_filetypes, filetype) >= 0
      call tagalong#Init()
      return
    endif
  endfor
endfunction

let &cpo = s:keepcpo
unlet s:keepcpo
