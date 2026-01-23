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

call plug#begin()

Plug 'github/copilot.vim'
Plug 'godlygeek/tabular'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'

call plug#end()

" Disable recording
map q <Nop>

let g:copilot_node_command = "~/.nvm/versions/node/v24.6.0/bin/node"
let g:copilot_filetypes = {
    \ 'gitcommit': v:true,
    \ 'markdown': v:true,
    \ 'yaml': v:true,
    \ 'toml': v:true
    \ }

 autocmd BufReadPre *
     \ let f=getfsize(expand("<afile>"))
     \ | if f > 100000 || f == -2
     \ | let b:copilot_enabled = v:false
     \ | endif

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>
nmap <silent> F  <Plug>(coc-fix-current)

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
" Snippets
" ----------------------------------------------

:imap <C-J> <Plug>snipMateNextOrTrigger
:smap <C-J> <Plug>snipMateNextOrTrigger

let g:snipMate = { 'snippet_version' : 1 }

" ----------------------------------------------
" Fonts
" ----------------------------------------------

if exists('g:GtkGuiLoaded')
  call rpcnotify(1, 'Gui', 'Font', 'Source Code Pro 12')
endif

function! BigFont()
  call rpcnotify(1, 'Gui', 'Font', 'Source Code Pro 18')
endfunction

function! SmallFont()
  call rpcnotify(1, 'Gui', 'Font', 'Source Code Pro 12')
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
" Terminal
" ----------------------------------------------

tnoremap <Esc> <C-\><C-n>

autocmd TermOpen * setlocal nonumber norelativenumber

set belloff=all

if &t_Co > 2 || has("gui_running")
    autocmd GUIEnter * set vb t_vb=
endif

" ----------------------------------------------
" Colors
" ----------------------------------------------

set termguicolors
set t_Co=256

" ----------------------------------------------
" Telescope
" ----------------------------------------------

nnoremap <C-p> <cmd>Telescope find_files<cr>

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

"nmap <silent> <leader>hl :SyntasticCheck hlint<CR>

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
autocmd BufNewFile,BufRead *.dl set filetype=souffle
autocmd BufNewFile,BufRead *.lean set filetype=lean

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

set guifont=Source\ Code\ Pro:h12
