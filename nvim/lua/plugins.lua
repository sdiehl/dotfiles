-- Plugin specs and plugin-specific configuration.

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
  -- Pinned to master: main branch requires Neovim 0.12 nightly + tree-sitter-cli.
  -- master is officially "locked but available for Nvim 0.11 backward compatibility".
  { "nvim-treesitter/nvim-treesitter", branch = "master", build = ":TSUpdate" },
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

-- ==============================================
-- PLUGIN VARIABLES & KEYMAPS
-- ==============================================

-- Copilot
vim.g.copilot_node_command = vim.fn.trim(vim.fn.system("which node"))
vim.g.copilot_filetypes = {
  gitcommit = true,
  markdown = true,
  yaml = true,
  toml = true,
  typst = true,
}

local copilot_grp = vim.api.nvim_create_augroup("sd_copilot", { clear = true })
vim.api.nvim_create_autocmd("BufReadPre", {
  group = copilot_grp,
  callback = function(args)
    local f = vim.fn.getfsize(vim.fn.expand("<afile>"))
    if f > 100000 or f == -2 then
      vim.b[args.buf].copilot_enabled = false
    end
  end,
})

-- Telescope
vim.keymap.set("n", "<C-p>", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<C-g>", "<cmd>Telescope live_grep<cr>")

-- Airline
vim.g["airline#extensions#default#section_truncate_width"] = {
  b = 79, x = 60, y = 88, z = 45,
  warning = 10000, error = 10000,
}

-- Fugitive
vim.keymap.set("n", "<leader>gd", ":Gdiff<CR>")
vim.keymap.set("n", "gb", ":Git blame<CR>")

-- Tabular
vim.keymap.set("v", "a=", ":Tabularize /=<CR>")
vim.keymap.set("v", "a;", ":Tabularize /::<CR>")
vim.keymap.set("v", "a,", ":Tabularize /,<CR>")
vim.keymap.set("v", "a-", ":Tabularize /-><CR>")

-- Neo-tree
vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>")

-- PostgreSQL
vim.g.sql_type_default = "pgsql"

-- ==============================================
-- LUA PLUGIN SETUP
-- ==============================================

local function safe_require(module)
  local ok, m = pcall(require, module)
  return ok and m or nil
end

local gitsigns = safe_require("gitsigns")
if gitsigns then gitsigns.setup() end

local comment = safe_require("Comment")
if comment then comment.setup() end

local autopairs = safe_require("nvim-autopairs")
if autopairs then autopairs.setup() end

local ibl = safe_require("ibl")
if ibl then ibl.setup() end

local whichkey = safe_require("which-key")
if whichkey then whichkey.setup() end

-- Telescope: send results to Trouble with <C-q>
local telescope = safe_require("telescope")
if telescope then
  local trouble_source = safe_require("trouble.sources.telescope")
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

local treesitter = safe_require("nvim-treesitter.configs")
if treesitter then
  treesitter.setup {
    ensure_installed = { "python", "rust", "lua", "vim", "json", "yaml", "toml", "markdown", "haskell", "sql" },
    highlight = { enable = true },
  }
end

-- ==============================================
-- LSP
-- ==============================================

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf = args.buf
    local opts = { buffer = buf, silent = true }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, opts)
  end,
})

-- rust-analyzer (native vim.lsp.config, Neovim 0.11+)
vim.lsp.config("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json" },
  settings = {
    ["rust-analyzer"] = {
      check = { command = "clippy" },
      cargo = { allFeatures = true },
    },
  },
})
vim.lsp.enable("rust_analyzer")

-- ==============================================
-- FORMAT ON SAVE (conform.nvim)
-- ==============================================

-- Rust: use nightly rustfmt (reads edition from Cargo.toml)
local conform = safe_require("conform")
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
