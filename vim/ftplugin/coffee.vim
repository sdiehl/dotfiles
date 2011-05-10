" Language:    CoffeeScript
" Maintainer:  Mick Koch <kchmck@gmail.com>
" URL:         http://github.com/kchmck/vim-coffee-script
" License:     WTFPL
" Some minor changes by Stephen <sdiehl@clarku.edu> also under WTFPL

if exists("b:did_ftplugin")
  finish
endif

let b:did_ftplugin = 1

setlocal formatoptions-=t formatoptions+=croql
setlocal comments=s:###,m:\ ,e:###,:#
setlocal commentstring=#\ %s

" Compile a visual block of Coffeescript
function! s:CoffeeView() range
    let l:selected = getline(a:firstline, a:lastline)
    let l:tempfile = tempname()
    try
        " write coffee to temp file.
        call writefile(l:selected, l:tempfile)
        botright new
        setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
        execute "$read !coffee -bp " . l:tempfile . ' || exit 0'
        set syntax=javascript
        setlocal nomodifiable
    finally
        " delete temp file.
        if filewritable(l:tempfile)
            call delete(l:tempfile)
        endif
    endtry
endfunction

" Execute a visual block of Coffeescript
function! s:CoffeeExec() range
    let l:selected = getline(a:firstline, a:lastline)
    let l:tempfile = tempname()
    try
        " write coffee to temp file.
        call writefile(l:selected, l:tempfile)
        botright new
        setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
        execute "$read !coffee " . l:tempfile . ' || exit 0'
        set syntax=javascript
        setlocal nomodifiable
    finally
        " delete temp file.
        if filewritable(l:tempfile)
            call delete(l:tempfile)
        endif
    endtry
endfunction

function! s:CoffeeFile()
    let l:file = bufname("%")
    botright new
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
    execute "$read !coffee -c " . l:file
    setlocal nomodifiable
endfunction


function! s:CoffeeMake() range 

  let compile_command = 'coffee -c '
  let current_file = shellescape(expand('%:p'))
  let cmd_output = system(compile_command . current_file)

  set makeprg=compile_command
  set errorformat=Error:\ In\ %f\\,\ %m\ on\ line\ %l,
                  \Error:\ In\ %f\\,\ Parse\ error\ on\ line\ %l:\ %m,
                  \%-G%.%#

  " if some warnings were found, we process them
  if strlen(cmd_output) > 0


    " write quickfix errors to a temp file 
    let quickfix_tmpfile_name = tempname()
    exe "redir! > " . quickfix_tmpfile_name
      silent echon cmd_output
    redir END

    " read in the errors temp file 
    execute "silent! cfile " . quickfix_tmpfile_name

    " open the quicfix window
    botright copen
    let s:qfix_buffer = bufnr("$")

    " delete the temp file
    call delete(quickfix_tmpfile_name)

  endif
endfunction

" Preview the output of a visual block of Coffeescript as Javascript
command! -range=% -narg=0 CoffeeView :<line1>,<line2>call s:CoffeeView()

" Execute a visual block of Coffeescript in the interpreter
command! -range=% -narg=0 CoffeeExec :<line1>,<line2>call s:CoffeeExec()

" Compile Coffeescript File
command! CoffeeCompile call s:CoffeeFile()
command! -bang -bar -nargs=* CoffeeMake call s:CoffeeMake()

" Compile the current file on write.
if exists("coffee_compile_on_save")
  autocmd BufWritePost *.coffee silent call s:CoffeeMake()
endif
