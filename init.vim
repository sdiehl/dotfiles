" Stephen Diehl init.vim
" Most aimed at Haskell / Python / LaTeX / C / LLVM

syntax on
filetype plugin indent on

set nocompatible
set number
set nowrap
set noshowmode
set tw=80
set formatprg=par
set pumheight=12
set conceallevel=0
set smartcase

set smarttab
set smartindent
set autoindent
set softtabstop=2
set shiftwidth=2
set expandtab
set vb
set nofoldenable

set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox,.stack-work
set wildmode=longest,list,full
set wildmenu

set inccommand=split

" Rebind escape to jj
:imap jj <Esc>

" Disable recording
map q <Nop>


call plug#begin('~/.vim/plugged')

" Themes
Plug 'kaicataldo/material.vim', { 'branch': 'main' }

" Full path fuzzy file, buffer, mru, tag, ... finder for Vim.
Plug 'ctrlpvim/ctrlp.vim'

" Terminal
Plug 'kassio/neoterm'

" Formatting
Plug 'sbdchd/neoformat'

" Whitespace
Plug 'bronson/vim-trailing-whitespace'

" Status Line
Plug 'itchyny/lightline.vim'

" Comments
Plug 'scrooloose/nerdcommenter'
"
" JSON
Plug 'tpope/vim-jdaddy'

" Repeat
Plug 'tpope/vim-repeat'

" Tabular
Plug 'godlygeek/tabular'

" Git
Plug 'tpope/vim-fugitive'

" Surround
Plug 'tpope/vim-surround'

" Snipmate
Plug 'garbas/vim-snipmate'

" Haskell formatting
Plug 'sdiehl/vim-ormolu'
"Plug 'sdiehl/vim-cabalfmt'

" Haskell
"Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'antoinemadec/coc-fzf'

Plug 'neovimhaskell/haskell-vim'
Plug 'josa42/vim-lightline-coc'

" OCaml
Plug 'ocaml/vim-ocaml'

" Zig
Plug 'ziglang/zig.vim'

" Lean Theorem prover
Plug 'leanprover/lean.vim'

" Utilities
Plug 'tomtom/tlib_vim'

call plug#end()

let g:coc_disable_startup_warning = 1

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
nmap <silent> F  <Plug>(coc-fix-current)

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

highlight link CoCFloating Visual

nmap <silent> <Leader>e <Plug>(coc-diagnostic-next)
nmap <silent> <Leader>ed <Plug>(coc-definition)
nmap <silent> <Leader>et <Plug>(coc-type-definition)
nmap <silent> <Leader>ei <Plug>(coc-implementation)
nmap <silent> <Leader>er <Plug>(coc-references)

autocmd CursorHold * silent call CocActionAsync('highlight')

set cmdheight=2

let g:airline#extensions#default#section_truncate_width = {
    \ 'b': 79,
    \ 'x': 60,
    \ 'y': 88,
    \ 'z': 45,
    \ 'warning': 10000,
    \ 'error': 10000,
    \ }

" ----------------------------------------------
" Stauts Line
" ----------------------------------------------

let g:lightline = {
  \   'active': {
  \   'left': [[ 'coc_errors', 'coc_warnings', 'coc_ok' ], [ 'coc_status'  ]]
  \   }
  \ }

" register compoments:
call lightline#coc#register()

" ----------------------------------------------
" Pathogen Manager
" ----------------------------------------------

execute pathogen#infect()

" ----------------------------------------------
" Language Server
" ----------------------------------------------

let g:LanguageClient_rootMarkers = ['*.cabal', 'stack.yaml']
let g:LanguageClient_serverCommands = {
    \ 'haskell': ['ghcide', '--lsp'],
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ }
set signcolumn=yes
"set updatetime=300

"nnoremap le :call LanguageClient#exit()<CR>
"nnoremap ls :call LanguageClient#startServer()<CR>
"
let g:LanguageClient_autoStart = v:true
let g:LanguageClient_hoverPreview = 'auto'
let g:LanguageClient_diagnosticsEnable = v:false
let g:LanguageClient_selectionUI = 'quickfix'

" ----------------------------------------------
" Snippets
" ----------------------------------------------

:imap <C-J> <Plug>snipMateNextOrTrigger
:smap <C-J> <Plug>snipMateNextOrTrigger

" ----------------------------------------------
" Fonts
" ----------------------------------------------

if exists('g:GtkGuiLoaded')
  call rpcnotify(1, 'Gui', 'Font', 'Fira Code 12')
endif

function! BigFont()
  call rpcnotify(1, 'Gui', 'Font', 'Fira Code 18')
endfunction

function! SmallFont()
  call rpcnotify(1, 'Gui', 'Font', 'Fira Code 12')
endfunction

map <Leader>bb :call BigFont()<CR>
map <Leader>ss :call SmallFont()<CR>

" ----------------------------------------------
" Colors
" ----------------------------------------------

"colorscheme NeoSolarized
"colorscheme onedark
colorscheme jellybeans
"colorscheme material
let g:material_terminal_italics = 1
let g:material_theme_style = 'darker'

" ----------------------------------------------
" Nightmode
" ----------------------------------------------

"if strftime("%H") < 20
"  set background=light
"else
"  set background=dark
"endif

" ----------------------------------------------
" Terminal
" ----------------------------------------------

tnoremap <Esc> <C-\><C-n>

autocmd TermOpen * setlocal nonumber norelativenumber

" ----------------------------------------------
" Colors
" ----------------------------------------------

set termguicolors
set t_Co=256

" ----------------------------------------------
" Tab Completion
" ----------------------------------------------

set completeopt=menuone,menu,longest
set completeopt+=longest

inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>

function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction

inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

" ----------------------------------------------
" CTRL+P
" ----------------------------------------------

map <silent> <Leader>t :CtrlP()<CR>
noremap <leader>b<space> :CtrlPBuffer<cr>
let g:ctrlp_custom_ignore = '\v[\/]dist$'
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard', '.stack-work', 'dist-newstyle']

" ----------------------------------------------
"  Indentation
" ----------------------------------------------

map <Leader>ig :IndentGuidesToggle<CR>

" ----------------------------------------------
" Fix trailing Whitespace
" ----------------------------------------------

" Autofix all whitespace on save
autocmd BufWritePre *.py :%s/\s\+$//e
" Delete all trailing empty lines on files
autocmd BufWritePre *.py :%s/\(\s*\n\)\+\%$//e

" Autofix all whitespace on save
autocmd BufWritePre *.hs :%s/\s\+$//e
" Delete all trailing empty lines on files
autocmd BufWritePre *.hs :%s/\(\s*\n\)\+\%$//e

" ----------------------------------------------
" GUI Options
" ----------------------------------------------

set mouse=a
set mousemodel=popup

set guioptions-=m
set guioptions-=r
set guioptions-=T
set guioptions-=L

set wildmenu
set wildmode=longest:list

set dictionary="/usr/dict/words"

nnoremap <leader>tl :vimgrep TODO % \| copen<CR>

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
" HTML
" ----------------------------------------------

let g:mta_use_matchparen_group = 1

" ----------------------------------------------
" Haskell
" ----------------------------------------------

let g:ormolu_options=["--unsafe", "-o -XTypeApplications"]
"let g:ormolu_disable=1
nnoremap tf :call RunOrmolu()<CR>
nnoremap to :call ToggleOrmolu()<CR>
xnoremap tb :<c-u>call OrmoluBlock()<CR>

let $PATH = $PATH . ':' . expand('~/.stack/bin')

nmap <silent> <leader>hl :SyntasticCheck hlint<CR>

" ----------------------------------------------
" Syntastic
" ----------------------------------------------

map <Leader>s :SyntasticToggleMode<CR>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

"let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['haskell'] }

" ----------------------------------------------
" Python
" ----------------------------------------------

autocmd bufnewfile,bufread *.py set formatprg=par

let g:neoformat_python_black = {
    \ 'exe': 'black',
    \ 'stdin': 1,
    \ 'args': ['-q', '-'],
    \ }
let g:neoformat_enabled_python = ['black']

" ----------------------------------------------
" C
" ----------------------------------------------

autocmd BufNewFile,BufRead *.c set formatprg=astyle
autocmd BufNewFile,BufRead *.h set formatprg=astyle
autocmd BufNewFile,BufRead *.cpp set formatprg=astyle

autocmd BufWritePre *.c try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
autocmd BufWritePre *.h try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry
autocmd BufWritePre *.py try | undojoin | Neoformat | catch /^Vim\%((\a\+)\)\=:E790/ | finally | silent Neoformat | endtry

" ----------------------------------------------
" Other Languages
" ----------------------------------------------

autocmd BufNewFile,BufRead *.y set filetype=happy
autocmd BufNewFile,BufRead *.x set filetype=alex
autocmd BufNewFile,BufRead *.agda set filetype=agda
autocmd BufNewFile,BufRead *.idr set filetype=idris
autocmd BufNewFile,BufRead *.ml set filetype=ocaml
autocmd BufNewFile,BufRead *.js set filetype=javascript
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufNewFile,BufRead *.ll set filetype=llvm
autocmd BufNewFile,BufRead *.scala set filetype=scala
autocmd BufNewFile,BufRead *.c set filetype=c
autocmd BufNewFile,BufRead *.fp set filetype=haskell

" ----------------------------------------------
" Pane Switching
" ----------------------------------------------

nnoremap <C-j> <C-W>w

nnoremap <C-j> <C-W>w

" tab navigation like firefox
map tn :tabnext<CR>
map tp :tabprevious<CR>

map <C-t> :tabnew<CR>

highlight SpellBad term=underline gui=underline guisp=Blue
highlight Error term=underline gui=underline guibg=#00ff00

"------------------------------------------------------------
" Window split
"------------------------------------------------------------

" Make splits equal size
noremap <silent> <F12> :wincmd =<CR>
autocmd VimResized * wincmd =

" ----------------------------------------------
" Autocorect
" ----------------------------------------------

ab teh the
ab sefl self
ab equivelant equivalent

" ----------------------------------------------
" Tabularize
" ----------------------------------------------

let g:haskell_tabular = 1

vmap a= :Tabularize /=<CR>
vmap a; :Tabularize /::<CR>
vmap a, :Tabularize /,<CR>
vmap a- :Tabularize /-><CR>

" ----------------------------------------------
" Git Version Traversal
" ----------------------------------------------

map gd :Gdiff<CR>
map gb :Gblame<CR>

" Git checkout at block level
vmap do :diffget<CR>
map gd :Gdiff<CR>

" ----------------------------------------------
" Fast Navigation
" ----------------------------------------------

" Go to last edited line one keystroke
map ` g;
map gl <C-^>

" ----------------------------------------------
" Searching
" ----------------------------------------------

set incsearch
map ff /\c

if &t_Co > 2 || has("gui_running")
    set hlsearch                "Highlight all search matches if color is
endif                           "possible (:noh to toggle off)
nnoremap <silent> <return> :noh<return>

" ----------------------------------------------
" Inactive Buffers
" ----------------------------------------------

function! Wipeout()
  " list of *all* buffer numbers
  let l:buffers = range(1, bufnr('$'))

  " what tab page are we in?
  let l:currentTab = tabpagenr()
  try
    " go through all tab pages
    let l:tab = 0
    while l:tab < tabpagenr('$')
      let l:tab += 1

      " go through all windows
      let l:win = 0
      while l:win < winnr('$')
        let l:win += 1
        " whatever buffer is in this window in this tab, remove it from
        " l:buffers list
        let l:thisbuf = winbufnr(l:win)
        call remove(l:buffers, index(l:buffers, l:thisbuf))
      endwhile
    endwhile

    " if there are any buffers left, delete them
    if len(l:buffers)
      execute 'bwipeout' join(l:buffers)
    endif
  finally
    " go back to our original tab page
    execute 'tabnext' l:currentTab
  endtry
endfunction

" ----------------------------------------------
" Writing Mode
" ----------------------------------------------

autocmd BufNewFile,BufRead *.rst,*.txt,*.tex,*.latex,*.md setlocal spell
autocmd BufNewFile,BufRead *.rst,*.txt,*.tex,*.latex,*.md setlocal nonumber

autocmd BufWritePre *.css,*.html,*.js undojoin | Neoformat

" ----------------------------------------------
" Clipboard
" ----------------------------------------------

set clipboard+=unnamedplus
set showmode
set shellslash
set showmatch
