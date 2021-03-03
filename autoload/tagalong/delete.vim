function! tagalong#delete#Visual()
  call tagalong#Trigger()
  normal! gvd
  call tagalong#Apply()
endfunction

function! tagalong#delete#Normal(type = '')
  if a:type == ''
    set opfunc=tagalong#delete#Normal
    return 'g@'
  endif

  let saved_range_start = getpos("'[")
  let saved_range_end = getpos("']")
  call tagalong#Trigger()
  call setpos("'[", saved_range_start)
  call setpos("']", saved_range_end)

  if a:type == 'line'
    normal! `[V`]d
  elseif a:type == 'char'
    normal! `[v`]d
  elseif a:type == 'block'
    exe "normal! `[\<c-v>`]d"
  else
    echoerr "Unknown opfunc type: ".a:type
  endif

  call tagalong#Apply()
endfunction
