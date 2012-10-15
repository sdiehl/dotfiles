" Stephen Diehl .vimrc
" Most aimed at Haskell / Python / C / LaTeX 
"
" This is about 5 years of love. Feel free to copy any of it!

syntax on                     " syntax highlighing
filetype on                   " try to detect filetypes
filetype plugin indent on     " enable loading indent file for filetype

set wildmenu                  " Menu completion in command mode on <Tab>
set wildmode=full             " <Tab> cycles between all matching choices.
set wildignore+=*.o,*.obj,.git,*.pyc,*png,*.h5,*.swo
set pumheight=12             " Keep a small completion window
set completeopt=menuone,menu,longest

" ----------------------------------------------
" Autcompletion
" ----------------------------------------------
au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
let g:ropevim_vim_completion=1
let g:ropevim_extended_complete=1

set smartcase
set smarttab
set smartindent
set autoindent

" ----------------------------------------------
" Less Uesd Languages
" ----------------------------------------------
autocmd BufNewFile,BufRead *.agda set filetype=agda
autocmd BufNewFile,BufRead *.ocaml set filetype=ocaml
autocmd BufNewFile,BufRead *.go set filetype=go
autocmd BufNewFile,BufRead *.pure set filetype=pure.purestd
autocmd BufNewFile,BufRead *.js set filetype=javascript
autocmd BufNewFile,BufRead *.coffee set filetype=coffee
autocmd BufNewFile,BufRead *.md set filetype=markdown
" ----------------------------------------------

" ----------------------------------------------
" C
" ----------------------------------------------
autocmd BufEnter *.c set formatprg=astyle\ --style=1tbs
autocmd BufEnter *.c compiler splint
autocmd BufWritePre *.c :%s/\s\+$//e

" ----------------------------------------------
" Haskell
" ----------------------------------------------
autocmd Bufenter *.hs compiler ghc
"autocmd Bufenter *.hs compiler hlint
autocmd BufEnter *.hs set formatprg=pointfree
vmap gw :!djinn<CR>

" ----------------------------------------------
" Python
" ----------------------------------------------
autocmd BufNewFile,BufRead *.py set formatprg=par

" ----------------------------------------------
" Autofix Python Whitespace
" ----------------------------------------------
" Autofix all whitespace on save
autocmd BufWritePre *.py :%s/\s\+$//e
" Delete all trailing empty lines on files
autocmd BufWritePre *.py :%s/\(\s*\n\)\+\%$//e
" ----------------------------------------------

set tw=110
"set statusline=%f\ %m%r\ [%Y]%=%(\ %l,%v\ @\ %p%%\ of\ %L\ %)
set formatprg=par

"X Clipboard
set clipboard=unnamedplus,autoselect

noremap <F11> :set invpaste paste?<CR>
set pastetoggle=<F11>
set showmode

set shellslash
set nocompatible
set showmatch

"Indentation Stuff"
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

"set t_Co=256
set mouse=a
set guioptions-=m
set guioptions-=r
set guioptions-=T
set guioptions-=L

set wrapmargin=15
set textwidth=65
set grepprg=grep\ -nH\ $*
set wrap nowrap
set laststatus=2

" Latex Stuff
let g:tex_flavor='latex'
let python_highlight_all=1

" The Line of Power
let g:Powerline_symbols = 'fancy'

map <silent> <Leader>m :!make > /dev/null &<CR>
map <Leader>n :NERDTreeToggle<CR>
map <Leader>u :source $MYVIMRC<CR>
map <Leader>ig :IndentGuidesToggle<CR>

" ----------------------------------------------
" CTRL+P
" ----------------------------------------------
map <silent> <Leader>t :CtrlP()<CR>

" ----------------------------------------------
" Haskell
" ----------------------------------------------
" Type Refresh
map <silent> tu :call GHC_BrowseAll()<CR>
" Type Lookup
map tt :call GHC_ShowType(0)<CR>
" Type Infer
map tw :call GHC_ShowType(1)<CR>
" Type Infer
map ti :call GHC_ShowInfo()<CR>
map trai :call GHC_MkImportsExplicit()<CR>

map <Leader>s :SyntasticToggleMode<CR>
if has("gui_running")
  map tghc :popup ]OPTIONS_GHC<cr>
else
  map tghc :emenu ]OPTIONS_GHC.
endif

if has("gui_running")
  map tlo :popup ]LANGUAGES_GHC<cr>
else
  map tlo :emenu ]LANGUAGES_GHC.
endif
" ----------------------------------------------
" Javascript, ick
" ----------------------------------------------
map <silent> <leader>jb :call g:Jsbeautify()<CR>
map <Leader>jl :JSLintUpdate<CR>

" configure browser for haskell_doc.vim
let g:haddock_browser = "chromium"


command! -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    ccl
    unlet g:qfix_win
  else
    copen 10
    let g:qfix_win = bufnr("$")
  endif
endfunction

" Coffeescript Stuff
"let coffee_compile_on_save=0
"map cv :CoffeeView<CR>
"map cm :CoffeeMake<CR>

func! Todos()
    exec "noautocmd vimgrep /TODO/j **/*.py"
    exec "cw"
endfunc

" ----------------------------------------------
" Flush
" ----------------------------------------------
" Flush swap files recursively in this directory, usefull if Vim
" crashes.
command! Flush :call Flush()
func! Flush()
    exec "!find . -name \".*.swp\" | xargs rm -f"
endfunc
" ----------------------------------------------

command! Todo :call Todos()
command! Pep8 :call Pep8()

func! CompileRunGcc()
  exec "w"
  exec "!gcc -g % -o %<"
  exec "! ./%<"
endfunc

if has("gui_running")
    " For gvim
    "colorscheme molokai
    colorscheme jellybeans
    set guifont=Monaco\ 10
    "set guifont=Envy\ Code\ R\ 9

    "hi Normal guifg=White
else
    " For terminal
    "colorscheme molokai
    colorscheme xoria256
    set guifont=ProggyCleanTT\ 12
    autocmd FocusGained * call s:CommandTFlush()
endif

"nnoremap <C-j> <C-W>w<C-W>_
nnoremap <C-j> <C-W>w

" tab navigation like firefox
map tn :tabnext<CR>
map tp :tabprevious<CR>

map <C-t> :tabnew<CR>
"map <C-w> :tabclose<CR>

vmap a= :Tabularize /=<CR>
vmap a; :Tabularize /:<CR>
vmap a, :Tabularize /,<CR>

highlight SpellBad term=underline gui=underline guisp=Blue
highlight Error term=underline gui=underline guibg=#00ff00

" Rope
map gt :RopeGotoDefinition<CR>

map rr :RopeRename<CR>
map rai :RopeAutoImport<CR>
map roi :RopeOrganizeImports<CR>
map rvt :VimroomToggle<CR>

fun! RopeLuckyAssistInsertMode()
    call RopeLuckyAssist()
    return ""
endfunction

" ----------------------------------------------
" Git Version Traversal
" ----------------------------------------------
map gd :Gdiff<CR>
map gb :Gblame<CR>
" Git checkout at block level
vmap do :diffget<CR>
map gd :Gdiff<CR>
" ----------------------------------------------

map fb :set guifont=Monaco\ 10<CR>:set lines=999 columns=999<CR>
map fs :set guifont=Monaco\ 8<CR>:set lines=999 columns=999<CR>

if (&tildeop)
  nmap gcw guw~l
  nmap gcW guW~l
  nmap gciw guiw~l
  nmap gciW guiW~l
  nmap gcis guis~l
  nmap gc$ gu$~l
  nmap gcgc guu~l
  nmap gcc guu~l
  vmap gc gu~l
else
  nmap gcw guw~h
  nmap gcW guW~h
  nmap gciw guiw~h
  nmap gciW guiW~h
  nmap gcis guis~h
  nmap gc$ gu$~h
  nmap gcgc guu~h
  nmap gcc guu~h
  vmap gc gu~h
endif

let ropevim_vim_completion = 1
let ropevim_extended_complete = 1
let g:ropevim_autoimport_modules = []

" ----------------------------------------------
" Fast Navigation
" ----------------------------------------------
" Use space to jump between paragraphs
map <Space> }}
map <S-Space> {{

" Go to last edited line one keystroke 
map ` g;
" ----------------------------------------------


" ----------------------------------------------
" Searching
" ----------------------------------------------
set incsearch
map ff /\c
" Inelegant grepping
nmap <c-f> :vimgrep  **/*.py<left><left><left><left><left><left><left><left>
" ----------------------------------------------


" ----------------------------------------------
" EasyMotion
" ----------------------------------------------
map ;; \\w
" ----------------------------------------------

" ----------------------------------------------
" Ropevim + Python
" ----------------------------------------------

let ropevim_codeassist_maxfixes=10
let ropevim_guess_project=1
let ropevim_vim_completion=1
let ropevim_enable_autoimport=1
let ropevim_extended_complete=1

" ----------------------------------------------
" PyFlakes
" ----------------------------------------------
" Quick Fix Window for Pyflakes
map cn :call CycleErrors()<CR>
map co :QFix<CR><CR>
imap <C-space> <Esc>a<Space><Esc>:call RopeLuckyAssistInsertMode()<CR>i

let g:pyflakes_use_quickfix = 1

function! TogglePyflakesQuickfix()
    if g:pyflakes_use_quickfix == 1
        echo "Disabled Pyflakes Quickfix"
        let g:pyflakes_use_quickfix = 0
        if &filetype == "Python"
            silent PyflakesUpdate
        endif
        call QFixToggle(0)
        call setqflist([])
    else
        echo "Enabled Pyflakes Quickfix"
        let g:pyflakes_use_quickfix = 1
        if &filetype == "Python"
            silent PyflakesUpdate
        endif
        call QFixToggle(1)
    endif
endfunction

noremap <f4> :call TogglePyflakesQuickfix()<cr>

function! CycleErrors()
  try
    cn
  catch /^Vim\%((\a\+)\)\=:E553/
    "try
      "next
    "catch /^Vim\%((\a\+)\)\=:E16[35]/
    cc 1
    "endtry
  catch /^Vim\%((\a\+)\)\=:E42/
  endtry
endfunction
" ----------------------------------------------


" ----------------------------------------------
" Tagbar
" ----------------------------------------------
nmap <leader>= :TagbarToggle<CR>
let g:tagbar_autofocus = 1
" ----------------------------------------------

ab teh the
ab sefl self
