"
" Navigate quicklist and location list windows conveniently
"
" I want a key, say, F4, that does :lnext or :cnext depending on whether the
" location list window associated with the current buffer is open or not
"

function! LocListOpen()
  let curwinnr = winnr()
  let mylist = getloclist(curwinnr)
  if mylist == []
    return 0
  endif
  for winnr in range(1, winnr('$'))
    if winnr != curwinnr
        \ && winbufnr(winnr) != -1
        \ && getwinvar(winnr, '&buftype') == 'quickfix'
        \ && getloclist(winnr) == mylist
      return 1
    endif
  endfor
  return 0
endf

function! ShowErrorUnderCursor()
  if LocListOpen()
    let mylist = getloclist(0)
  else
    let mylist = getqflist()
  endif
  let curbufnr = bufnr("")
  let curlnum = line(".")
  for d in mylist
    if d.bufnr == curbufnr && d.lnum == curlnum
      " force a redraw, or our echo will get cleared
      " note that this may get called more than once
      redraw
      echo d.text
    endif
    if d.bufnr == curbufnr && d.lnum > curlnum
      return
    endif
  endfor
endf

command! -bar ShowErrorUnderCursor :call ShowErrorUnderCursor()

" making this a function would produce extra output on errors
command! -bar FirstOrNextInList
        \ if !exists("g:quickloclist_first") <bar>
        \     let g:quickloclist_first=0 <bar>
        \ endif <bar>
        \ if LocListOpen() <bar>
        \   if g:quickloclist_first <bar>
        \     ll <bar>
        \   else <bar>
        \     lnext <bar>
        \   endif <bar>
        \ else <bar>
        \   if g:quickloclist_first <bar>
        \     cc <bar>
        \   else <bar>
        \     cn <bar>
        \   endif <bar>
        \ endif <bar>
        \ ShowErrorUnderCursor <bar>
        \ let g:quickloclist_first=0
command! -bar NextInList :if LocListOpen() <bar> :lnext <bar> else <bar> :cn <bar> endif <bar> ShowErrorUnderCursor
command! -bar PrevInList :if LocListOpen() <bar> :lprev <bar> else <bar> :cp <bar> endif <bar> ShowErrorUnderCursor
command! -bar CurInList :if LocListOpen() <bar> :ll <bar> else <bar> :cc <bar> endif <bar> ShowErrorUnderCursor

augroup QuickLocList
  autocmd!
  autocmd FileType qf let g:quickloclist_first=1
augroup END
