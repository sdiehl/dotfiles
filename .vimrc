nnoremap <buffer> o <CR><C-W>p
syntax on                     " syntax highlighing
filetype on                   " try to detect filetypes
filetype plugin indent on     " enable loading indent file for filetype

set wildmenu                  " Menu completion in command mode on <Tab>
set wildmode=full             " <Tab> cycles between all matching choices.
set wildignore+=*.o,*.obj,.git,*.pyc,*png
set pumheight=12             " Keep a small completion window
set completeopt=menuone,menu,longest

au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
let g:ropevim_vim_completion=1
let g:ropevim_extended_complete=1

set smartcase
set smarttab
set smartindent
set autoindent

autocmd BufNewFile,BufRead *.coffee set filetype=coffee
autocmd BufNewFile,BufRead *Cakefile set filetype=coffee
autocmd BufNewFile,BufRead *.pure set filetype=pure.purestd
autocmd BufNewFile,BufRead *.t set filetype=slipstream
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

" Autofix all whitespace on save
autocmd BufWritePre *.py :%s/\s\+$//e
" Delete all trailing empty lines on files
autocmd BufWritePre *.py :%s/\(\s*\n\)\+\%$//e

set tw=110
set statusline=%f\ %m%r\ [%Y]%=%(\ %l,%v\ @\ %p%%\ of\ %L\ %)
set formatprg=par

"X Clipboard
set clipboard=unnamedplus,autoselect

noremap <F11> :set invpaste paste?<CR>
set pastetoggle=<F11>
set showmode

set shellslash
set grepprg=grep\ -nH\ $*
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

map <silent> <Leader>m :!make > /dev/null &<CR>
map <Leader>n :NERDTreeToggle<CR>
map <Leader>u :source $MYVIMRC<CR>
map <F12> :!kill -HUP `cat gunicorn.pid`<CR>
map <Leader>ig :IndentGuidesToggle<CR>

" Javascript
map <silent> <leader>jb :call g:Jsbeautify()<CR>
map <Leader>jl :JSLintUpdate<CR>

" Python
map <silent> <leader>jb :call g:Jsbeautify()<CR>
"map <Leader>t :noautocmd vimgrep /TODO/j **/*.py<CR>:cw<CR>
map <silent> <Leader>pl :call Pep8()<CR>
map <silent> <Leader>t :CtrlP()<CR>

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

"map <silent> <Leader>c :CoveragePy report<CR>
"map <silent> <Leader>c :QFix<CR>

" Coffeescript Stuff
let coffee_compile_on_save=0
"map cv :CoffeeView<CR>
"map cm :CoffeeMake<CR>

func! Todos()
    exec "noautocmd vimgrep /TODO/j **/*.py"
    exec "cw"
endfunc

func! Flush()
    exec "!find . -name \".*.swp\" | xargs rm -f"
endfunc

command! Todo :call Todos()
command! Pep8 :call Pep8()
command! Flush :call Flush()

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

    hi Normal guifg=White
else
    " For terminal
    "colorscheme molokai
    colorscheme xoria256
    set guifont=ProggyCleanTT\ 12
    autocmd FocusGained * call s:CommandTFlush()
endif

nnoremap <C-j> <C-W>w<C-W>_

" tab navigation like firefox
map tn :tabnext<CR>
map tp :tabprevious<CR>

map <C-t> :tabnew<CR>
map <C-w> :tabclose<CR>

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

" Quick Fix Window for Pyflakes
map cn :call CycleErrors()<CR>
map <silent> co :QFix<CR><CR>
map cc :RopeLuckyAssist<CR>

" Git
map gd :Gdiff<CR>
map gb :Gblame<CR>
" Git checkout at block level
vmap do :diffget<CR>

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

map <Space> }}
map ;; \\w

set incsearch
map ff /\c

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
