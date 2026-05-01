" Stephen Diehl init.vim

" ==============================================
" LAZY.NVIM BOOTSTRAP
" ==============================================

lua << EOF
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Core
  { "github/copilot.vim" },
  { "nvim-lua/plenary.nvim", lazy = true },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "MunifTanjim/nui.nvim", lazy = true },
  { "nvim-neo-tree/neo-tree.nvim", dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" } },
  { "vim-airline/vim-airline" },
  { "tpope/vim-fugitive" },
  { "godlygeek/tabular", cmd = "Tabularize" },

  -- Editor enhancements
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "lewis6991/gitsigns.nvim" },
  { "numToStr/Comment.nvim" },
  { "windwp/nvim-autopairs" },
  { "lukas-reineke/indent-blankline.nvim" },
  { "folke/which-key.nvim" },

  -- Diagnostics panel
  { "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Defs / Refs (Trouble)" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    },
    opts = {
      auto_close = true,
      focus = false,
    },
  },

  -- Format on save
  { "stevearc/conform.nvim" },

  -- Language syntax (lazy-loaded by filetype)
  { "neovimhaskell/haskell-vim", ft = "haskell" },
  { "rust-lang/rust.vim", ft = "rust" },
  { "whonore/Coqtail", ft = "coq" },
  { "derekelkins/agda-vim", ft = "agda" },
  { "edwinb/idris2-vim", ft = { "idris", "idris2" } },
  { "souffle-lang/souffle.vim", ft = "souffle" },
  { "lifepillar/pgsql.vim", ft = { "sql", "pgsql" } },

  -- Lean: LSP + infoview (proof state)
  { "neovim/nvim-lspconfig", lazy = true },
  {
    "Julian/lean.nvim",
    ft = "lean",
    dependencies = { "neovim/nvim-lspconfig", "nvim-lua/plenary.nvim" },
    opts = {
      mappings = true,
      infoview = {
        autoopen = true,
        width = 50,
        horizontal_position = "bottom",
      },
      lsp = { on_attach = function() end },
    },
  },
}, {
  ui = { border = "rounded" },
  checker = { enabled = false },
  change_detection = { notify = false },
})
EOF

" ==============================================
" SETTINGS
" ==============================================

syntax on
filetype plugin indent on

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
set undofile

set incsearch
set hlsearch
set ignorecase
set smartcase
set inccommand=split

set pumheight=12
set wildmenu
set wildmode=longest,list,full
set wildignore+=*/tmp/*,*.swp,*.swo,*.zip,.git

set termguicolors
colorscheme jellybeans

" ==============================================
" KEYBINDINGS
" ==============================================

nnoremap q <Nop>
nnoremap <leader>/ /\c
nnoremap <silent> <CR> :noh<CR>

nnoremap <C-j> <C-W>w
nnoremap ` g;
nnoremap gl <C-^>

nnoremap <C-t> :tabnew<CR>
nnoremap tn :tabnext<CR>
nnoremap tp :tabprevious<CR>

noremap <silent> <F12> :wincmd =<CR>

augroup sd_windows
  autocmd!
  autocmd VimResized * wincmd =
  autocmd TermOpen * setlocal nonumber norelativenumber
augroup END

tnoremap <Esc> <C-\><C-n>

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
augroup sd_copilot
  autocmd!
  autocmd BufReadPre * let f=getfsize(expand("<afile>"))
      \ | if f > 100000 || f == -2 | let b:copilot_enabled = v:false | endif
augroup END

" Telescope
nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <C-g> <cmd>Telescope live_grep<cr>

" Airline
let g:airline#extensions#default#section_truncate_width = {
    \ 'b': 79, 'x': 60, 'y': 88, 'z': 45,
    \ 'warning': 10000, 'error': 10000 }

" Fugitive
nnoremap <leader>gd :Gdiff<CR>
nnoremap gb :Git blame<CR>

" Tabular
vnoremap a= :Tabularize /=<CR>
vnoremap a; :Tabularize /::<CR>
vnoremap a, :Tabularize /,<CR>
vnoremap a- :Tabularize /-><CR>

" PostgreSQL
let g:sql_type_default = 'pgsql'

" Lua plugin setup
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

-- Telescope: send results to Trouble with <C-q>
local telescope = safe_require('telescope')
if telescope then
  local trouble_source = safe_require('trouble.sources.telescope')
  if trouble_source then
    telescope.setup({
      defaults = {
        mappings = {
          i = { ["<c-q>"] = trouble_source.open },
          n = { ["<c-q>"] = trouble_source.open },
        },
      },
    })
  end
end

local treesitter = safe_require('nvim-treesitter.configs')
if treesitter then
  treesitter.setup {
    ensure_installed = { "python", "rust", "lua", "vim", "json", "yaml", "toml", "markdown", "haskell", "sql" },
    highlight = { enable = true },
  }
end

-- LSP: rust-analyzer (native vim.lsp.config, Neovim 0.11+)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local buf = args.buf
    local opts = { buffer = buf, silent = true }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, opts)
    vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, opts)
  end,
})

vim.lsp.config('rust_analyzer', {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml', 'rust-project.json' },
  settings = {
    ["rust-analyzer"] = {
      check = { command = "clippy" },
      cargo = { allFeatures = true },
    },
  },
})
vim.lsp.enable('rust_analyzer')

-- Format on save (conform.nvim)
-- Rust: use nightly rustfmt (reads edition from Cargo.toml)
local conform = safe_require('conform')
if conform then
  conform.setup({
    formatters_by_ft = {
      rust = { "rustfmt" },
      markdown = { "dprint" },
      python = { "black" },
      toml = { "taplo" },
      json = { "prettier" },
      jsonc = { "prettier" },
      yaml = { "prettier" },
      sh = { "shfmt" },
      bash = { "shfmt" },
    },
    format_on_save = {
      timeout_ms = 2000,
      lsp_format = "fallback",
    },
    formatters = {
      rustfmt = {
        command = "rustup",
        args = { "run", "nightly", "rustfmt", "--edition", "2024", "--emit", "stdout" },
      },
      dprint = {
        command = "dprint",
        args = { "fmt", "--stdin", "$FILENAME" },
      },
    },
  })
end
EOF

" ==============================================
" FILETYPES
" ==============================================

augroup sd_filetypes
  autocmd!
  autocmd BufNewFile,BufRead *.y set filetype=happy
  autocmd BufNewFile,BufRead *.x set filetype=alex
  autocmd BufNewFile,BufRead *.agda set filetype=agda
  autocmd BufNewFile,BufRead *.idr set filetype=idris
  autocmd BufNewFile,BufRead *.ll set filetype=llvm
  autocmd BufNewFile,BufRead *.fp set filetype=haskell
  autocmd BufNewFile,BufRead *.dl set filetype=souffle
  autocmd BufNewFile,BufRead *.lean set filetype=lean
  autocmd BufNewFile,BufRead *.typ set filetype=typst
  autocmd BufNewFile,BufRead *.v set filetype=coq
  autocmd BufNewFile,BufRead *.rst,*.txt,*.tex,*.latex,*.md,*.typ setlocal spell nonumber
augroup END

augroup sd_trailing_whitespace
  autocmd!
  autocmd BufWritePre *.py,*.hs :%s/\s\+$//e
  autocmd BufWritePre *.py,*.hs :%s/\(\s*\n\)\+\%$//e
augroup END

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
