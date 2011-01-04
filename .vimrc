syntax on

filetype plugin on
filetype plugin indent on
filetype indent on

"autocmd FileType python set omnifunc=pythoncomplete#Complete
"autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
"autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd BufNewFile,BufRead *.coffee set filetype=coffee
autocmd BufNewFile,BufRead *Cakefile set filetype=coffee
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python set ft=python.django " For SnipMate
autocmd FileType html set ft=htmldjango.html " For SnipMate

"X Clipboard
set clipboard=unnamed

set shellslash
set ofu=syntaxcomplete#Complete#
set grepprg=grep\ -nH\ $*
set nocompatible
set showmatch

"Indentation Stuff"
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab

set t_Co=256color
set mouse=a
set guioptions-=m
set guioptions-=r
set guioptions-=T
set guioptions-=L

set wrapmargin=15
set textwidth=65
set grepprg=grep\ -nH\ $*
set wrap nowrap

let g:tex_flavor='latex'
let python_highlight_all = 1
let g:tex_flavor = "latex"
"Compile Coffeescript on Save
let coffee_compile_on_save=1

map <Leader>p :!pure -i %<CR>
map <Leader>y :!python2 %<CR>
map <Leader>h :!ghc % <CR>!./a.out<CR>
map <Leader>c :call CompileRunGcc()<CR>
map <Leader>m :call MakeRun()<CR>
map <Leader>f :FufBuffer<CR>
map <Leader>n :NERDTreeToggle<CR>
map <Leader>j :JSLintUpdate<CR>
map <Leader>t :noautocmd vimgrep /TODO/j **/*.py<CR>:cw<CR>
map <Leader>u :source $MYVIMRC<CR>
map <F12> :!kill -HUP `cat gunicorn.pid`<CR>

noremap <F11> :set invpaste paste?<CR>
set pastetoggle=<F11>
set showmode

func! CompileRunGcc()
  exec "w"
  exec "!gcc -g % -o %<"
  exec "! ./%<"
endfunc

func! MakeRun()
  exec "w"
  exec "make all"
  exec "! ./%<"
endfunc

colorscheme molokai
set guifont=ProggyCleanTT\ 12
