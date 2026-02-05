" Stephen Diehl init.vim

" ==============================================
" PLUGINS
" ==============================================

call plug#begin()

" Core
Plug 'github/copilot.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'godlygeek/tabular'

" Editor enhancements
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'lewis6991/gitsigns.nvim'
Plug 'numToStr/Comment.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'folke/which-key.nvim'

" Language syntax
Plug 'neovimhaskell/haskell-vim'
Plug 'rust-lang/rust.vim'
Plug 'whonore/Coqtail'
Plug 'derekelkins/agda-vim'
Plug 'edwinb/idris2-vim'
Plug 'souffle-lang/souffle.vim'
Plug 'lifepillar/pgsql.vim'

call plug#end()

" ==============================================
" SETTINGS
" ==============================================

syntax on
filetype plugin indent on

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
set timeoutlen=500

set smarttab
set smartindent
set autoindent
set softtabstop=2
set shiftwidth=2
set expandtab
set nofoldenable

set incsearch
set hlsearch
set smartcase
set inccommand=split

set pumheight=12
set wildmenu
set wildmode=longest,list,full
set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox,.stack-work

set termguicolors
set t_Co=256
colorscheme jellybeans

" ==============================================
" KEYBINDINGS
" ==============================================

map q <Nop>
map ff /\c
nnoremap <silent> <CR> :noh<CR>

nnoremap <C-j> <C-W>w
map ` g;
map gl <C-^>

map <C-t> :tabnew<CR>
map tn :tabnext<CR>
map tp :tabprevious<CR>

noremap <silent> <F12> :wincmd =<CR>
autocmd VimResized * wincmd =

tnoremap <Esc> <C-\><C-n>
autocmd TermOpen * setlocal nonumber norelativenumber

nnoremap <C-n> :Neotree toggle<CR>

" ==============================================
" PLUGIN CONFIG
" ==============================================

" Copilot
let g:copilot_node_command = trim(system('which node'))
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

" PostgreSQL
let g:sql_type_default = 'pgsql'

" Lua plugin setup (guarded for first-time install)
lua << EOF
local function safe_require(module)
  local ok, m = pcall(require, module)
  return ok and m or nil
end

local gitsigns = safe_require('gitsigns')
if gitsigns then gitsigns.setup() end

local comment = safe_require('Comment')
if comment then comment.setup() end

local autopairs = safe_require('nvim-autopairs')
if autopairs then autopairs.setup() end

local ibl = safe_require('ibl')
if ibl then ibl.setup() end

local whichkey = safe_require('which-key')
if whichkey then whichkey.setup() end

local treesitter = safe_require('nvim-treesitter.configs')
if treesitter then
  treesitter.setup {
    ensure_installed = { "python", "rust", "lua", "vim", "json", "yaml", "toml", "markdown", "haskell", "sql" },
    highlight = { enable = true },
  }
end
EOF

" ==============================================
" FILETYPES
" ==============================================

autocmd BufNewFile,BufRead *.y set filetype=happy
autocmd BufNewFile,BufRead *.x set filetype=alex
autocmd BufNewFile,BufRead *.agda set filetype=agda
autocmd BufNewFile,BufRead *.idr set filetype=idris
autocmd BufNewFile,BufRead *.ll set filetype=llvm
autocmd BufNewFile,BufRead *.fp set filetype=haskell
autocmd BufNewFile,BufRead *.dl set filetype=souffle
autocmd BufNewFile,BufRead *.lean set filetype=lean
autocmd BufNewFile,BufRead *.typ set filetype=typst
autocmd BufNewFile,BufRead *.kk set filetype=koka
autocmd BufNewFile,BufRead *.v set filetype=coq

autocmd BufNewFile,BufRead *.rst,*.txt,*.tex,*.latex,*.md,*.typ setlocal spell nonumber

autocmd BufWritePre *.py,*.hs :%s/\s\+$//e
autocmd BufWritePre *.py,*.hs :%s/\(\s*\n\)\+\%$//e

" ==============================================
" UTILITIES
" ==============================================

ab teh the
ab sefl self
ab equivelant equivalent

command! Flush exec "!find . -name '.*.swp' | xargs rm -f"

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
