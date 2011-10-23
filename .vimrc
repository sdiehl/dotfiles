syntax on                     " syntax highlighing
filetype on                   " try to detect filetypes
filetype plugin indent on     " enable loading indent file for filetype
set background=dark
set wildmenu                  " Menu completion in command mode on <Tab>
set wildmode=full             " <Tab> cycles between all matching choices.
" Ignore these files when completing
set wildignore+=*.o,*.obj,.git,*.pyc 

""" Insert completion
" don't select first item, follow typing in autocomplete
set pumheight=6             " Keep a small completion window
set completeopt=menuone,menu,longest,preview
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
imap <c-space> <c-x><c-o>

" Tab Completion Stuff
" Try different completion methods depending on its context
let g:SuperTabDefaultCompletionType = "context"

" Add the virtualenv's site-packages to vim path
"py << EOF
"import os.path
"import sys
"import vim
"if 'VIRTUALENV' in os.environ:
    "project_base_dir = os.environ['VIRTUAL_ENV']
    "sys.path.insert(0, project_base_dir)
    "activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    "execfile(activate_this, dict(__file__=activate_this))
"EOF

"" Load up virtualenv's vimrc if it exists
"if filereadable($VIRTUAL_ENV . '/.vimrc')
    "source $VIRTUAL_ENV/.vimrc
"endif

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd BufNewFile,BufRead *.coffee set filetype=coffee
autocmd BufNewFile,BufRead *Cakefile set filetype=coffee
autocmd BufNewFile,BufRead *.pure set filetype=pure.purestd
autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python set ft=python.django " For SnipMate
autocmd FileType html set ft=htmldjango.html " For SnipMate

autocmd BufNewFile,BufRead *.tpl set filetype=haml
autocmd FileType haml set noexpandtab
autocmd FileType haml set shiftwidth=2 tabstop=2 softtabstop=2

" Close autocomplet window upon selection
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

set tw=110

"X Clipboard
set clipboard=unnamed
noremap <F11> :set invpaste paste?<CR>
set pastetoggle=<F11>
set showmode

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

set t_Co=256
set mouse=a
set guioptions-=m
set guioptions-=r
set guioptions-=T
set guioptions-=L

set wrapmargin=15
set textwidth=65
set grepprg=grep\ -nH\ $*
set wrap nowrap

" Latex Stuff
let g:tex_flavor='latex'
let python_highlight_all = 1
let g:tex_flavor = "latex"


"map <Leader>p :!pure -i %<CR>
"map <Leader>y :!python2 %<CR>
"map <Leader>h :!ghc % <CR>!./a.out<CR>
"map <Leader>c :call CompileRunGcc()<CR>
map <silent> <Leader>m :!make > /dev/null &<CR>
map <Leader>f :FufBuffer<CR>
map <Leader>n :NERDTreeToggle<CR>
map <Leader>u :source $MYVIMRC<CR>
map <F12> :!kill -HUP `cat gunicorn.pid`<CR>
map <Leader>ig :IndentGuidesToggle<CR>

" Javascript
map <silent> <leader>jb :call g:Jsbeautify()<CR>
map <Leader>jl :JSLintUpdate<CR>

" Python
map <silent> <leader>jb :call g:Jsbeautify()<CR>
map <Leader>t :noautocmd vimgrep /TODO/j **/*.py<CR>:cw<CR>
map <silent> <Leader>pl :call Pep8()<CR>

" Coffeescript Stuff
let coffee_compile_on_save=0
map cv :CoffeeView<CR>
map cm :CoffeeMake<CR>

func! Todos()
    exec "noautocmd vimgrep /TODO/j **/*.py"
    exec "cw"
endfunc

command! Todo :call Todos()
command! Pep8 :call Pep8()

func! CompileRunGcc()
  exec "w"
  exec "!gcc -g % -o %<"
  exec "! ./%<"
endfunc

func! MakeRun()
  exec "w"
  exec "make"
endfunc

if has("gui_running") 
    " For gvim
    colorscheme darkspectrum
    set guifont=Monaco\ 8
else
    " For terminal
    colorscheme molokai
    set guifont=ProggyCleanTT\ 12
endif


