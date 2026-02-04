" Stephen Diehl init.vim

" ==============================================
" PLUGINS
" ==============================================

call plug#begin()
Plug 'github/copilot.vim'           " AI completion
Plug 'nvim-lua/plenary.nvim'        " Lua utilities (required by telescope/neo-tree)
Plug 'nvim-telescope/telescope.nvim'" Fuzzy finder
Plug 'nvim-tree/nvim-web-devicons'  " File icons
Plug 'MunifTanjim/nui.nvim'         " UI components
Plug 'nvim-neo-tree/neo-tree.nvim'  " File explorer
Plug 'vim-airline/vim-airline'      " Status line
Plug 'tpope/vim-fugitive'           " Git integration
Plug 'godlygeek/tabular'            " Text alignment
call plug#end()

" ==============================================
" SETTINGS
" ==============================================

syntax on
filetype plugin indent on

" Editor
set nocompatible
set number
set nowrap
set noshowmode
set showmatch
set conceallevel=0
set belloff=all
set mouse=a
set clipboard+=unnamedplus
set tw=80
set cmdheight=2

" Indentation
set smarttab
set smartindent
set autoindent
set softtabstop=2
set shiftwidth=2
set expandtab
set nofoldenable

" Search
set incsearch
set hlsearch
set smartcase
set inccommand=split

" Completion
set pumheight=12
set wildmenu
set wildmode=longest,list,full
set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox,.stack-work

" Colors
set termguicolors
set t_Co=256
colorscheme jellybeans

" ==============================================
" KEYBINDINGS
" ==============================================

" Disable recording
map q <Nop>

" Search
map ff /\c
nnoremap <silent> <CR> :noh<CR>

" Navigation
nnoremap <C-j> <C-W>w
map ` g;
map gl <C-^>

" Tabs
map <C-t> :tabnew<CR>
map tn :tabnext<CR>
map tp :tabprevious<CR>

" Window
noremap <silent> <F12> :wincmd =<CR>
autocmd VimResized * wincmd =

" Terminal
tnoremap <Esc> <C-\><C-n>
autocmd TermOpen * setlocal nonumber norelativenumber

" ==============================================
" PLUGIN CONFIG
" ==============================================

" Copilot
let g:copilot_node_command = "~/.nvm/versions/node/v24.6.0/bin/node"
let g:copilot_filetypes = {
    \ 'gitcommit': v:true,
    \ 'markdown': v:true,
    \ 'yaml': v:true,
    \ 'toml': v:true,
    \ 'typst': v:true
    \ }
autocmd BufReadPre * let f=getfsize(expand("<afile>"))
    \ | if f > 100000 || f == -2 | let b:copilot_enabled = v:false | endif

" Telescope
nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <C-g> <cmd>Telescope live_grep<cr>

" Airline
let g:airline#extensions#default#section_truncate_width = {
    \ 'b': 79, 'x': 60, 'y': 88, 'z': 45,
    \ 'warning': 10000, 'error': 10000 }

" Fugitive
map gd :Gdiff<CR>
map gb :Git blame<CR>
vmap do :diffget<CR>

" Tabular
vmap a= :Tabularize /=<CR>
vmap a; :Tabularize /::<CR>
vmap a, :Tabularize /,<CR>
vmap a- :Tabularize /-><CR>

" ==============================================
" FILETYPES
" ==============================================

" Custom filetypes
autocmd BufNewFile,BufRead *.y set filetype=happy
autocmd BufNewFile,BufRead *.x set filetype=alex
autocmd BufNewFile,BufRead *.agda set filetype=agda
autocmd BufNewFile,BufRead *.idr set filetype=idris
autocmd BufNewFile,BufRead *.ll set filetype=llvm
autocmd BufNewFile,BufRead *.fp set filetype=haskell
autocmd BufNewFile,BufRead *.dl set filetype=souffle
autocmd BufNewFile,BufRead *.lean set filetype=lean
autocmd BufNewFile,BufRead *.typ set filetype=typst

" Prose: enable spelling, disable line numbers
autocmd BufNewFile,BufRead *.rst,*.txt,*.tex,*.latex,*.md,*.typ setlocal spell nonumber

" Strip trailing whitespace on save
autocmd BufWritePre *.py,*.hs :%s/\s\+$//e
autocmd BufWritePre *.py,*.hs :%s/\(\s*\n\)\+\%$//e

" ==============================================
" UTILITIES
" ==============================================

" Autocorrect
ab teh the
ab sefl self
ab equivelant equivalent

" Flush swap files
command! Flush exec "!find . -name '.*.swp' | xargs rm -f"

" Wipe inactive buffers
function! Wipeout()
  let l:buffers = range(1, bufnr('$'))
  let l:currentTab = tabpagenr()
  try
    for l:tab in range(1, tabpagenr('$'))
      for l:win in range(1, winnr('$'))
        call remove(l:buffers, index(l:buffers, winbufnr(l:win)))
      endfor
    endfor
    if len(l:buffers) | execute 'bwipeout' join(l:buffers) | endif
  finally
    execute 'tabnext' l:currentTab
  endtry
endfunction
