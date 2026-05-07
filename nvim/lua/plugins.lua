-- Plugin specs and plugin-specific configuration.

require("lazy").setup({
  -- Colorscheme: Lua-native jellybeans port (covers modern treesitter capture groups)
  { "rktjmp/lush.nvim", lazy = true },
  {
    "metalelf0/jellybeans-nvim",
    lazy = false,
    priority = 1000,
    dependencies = { "rktjmp/lush.nvim" },
    config = function()
      vim.cmd.colorscheme("jellybeans-nvim")
    end,
  },

  -- Copilot (Lua port: faster, lazy-loadable, better integration)
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = "Copilot",
    opts = {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<Tab>",
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      panel = { enabled = false },
      filetypes = { ["*"] = true },
    },
  },

  -- Plenary (shared dep)
  { "nvim-lua/plenary.nvim", lazy = true },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<C-g>", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    },
    config = function()
      local trouble_source = require("trouble.sources.telescope")
      require("telescope").setup({
        defaults = {
          mappings = {
            i = { ["<c-q>"] = trouble_source.open },
            n = { ["<c-q>"] = trouble_source.open },
          },
        },
      })
    end,
  },

  -- Web devicons / nui
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "MunifTanjim/nui.nvim", lazy = true },

  -- Neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    keys = {
      { "<C-n>", "<cmd>Neotree toggle<cr>", desc = "Neo-tree toggle" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "auto",
        section_separators = "",
        component_separators = "|",
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- Fugitive
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiff", "Gblame", "Gread", "Gwrite", "Gedit" },
    keys = {
      { "<leader>gd", "<cmd>Gdiff<cr>", desc = "Git diff" },
      { "gb", "<cmd>Git blame<cr>", desc = "Git blame" },
    },
  },

  -- Alignment (replaces godlygeek/tabular which was last touched in 2018)
  {
    "junegunn/vim-easy-align",
    cmd = "EasyAlign",
    keys = {
      { "ga", "<Plug>(EasyAlign)", mode = { "n", "x" }, desc = "Align (interactive)" },
      { "a=", ":EasyAlign =<cr>", mode = "x", desc = "Align by =" },
      { "a;", ":EasyAlign /::/<cr>", mode = "x", desc = "Align by ::" },
      { "a,", ":EasyAlign ,<cr>", mode = "x", desc = "Align by ," },
      { "a-", ":EasyAlign /->/<cr>", mode = "x", desc = "Align by ->" },
    },
  },

  -- Treesitter (master branch: locked but supported on Nvim 0.11)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- Register Julian/tree-sitter-lean (not in nvim-treesitter master registry).
      -- Same author as lean.nvim. parser.c + scanner.c are pre-generated, so no
      -- tree-sitter CLI needed.
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.lean = {
        install_info = {
          url = "https://github.com/Julian/tree-sitter-lean",
          files = { "src/parser.c", "src/scanner.c" },
          branch = "main",
        },
        filetype = "lean",
      }

      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "python",
          "rust",
          "lua",
          "vim",
          "vimdoc",
          "json",
          "yaml",
          "toml",
          "markdown",
          "markdown_inline",
          "haskell",
          "sql",
          "bash",
          "dockerfile",
          "regex",
          "query",
          "comment",
          -- "latex" requires tree-sitter CLI to build; built-in tex syntax is fine.
          "bibtex",
          "typst",
          "lean", -- via custom parser_config registered above (Julian/tree-sitter-lean)
        },
        highlight = { enable = true },
      })
    end,
  },

  -- Completion
  {
    "saghen/blink.cmp",
    lazy = false,
    version = "1.*",
    opts = {
      keymap = { preset = "default" },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        menu = { auto_show = true },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      signature = { enabled = true },
    },
  },

  -- Editor enhancements
  { "lewis6991/gitsigns.nvim", event = "VeryLazy", opts = {} },
  { "numToStr/Comment.nvim", event = "VeryLazy", opts = {} },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = { check_ts = true } },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    main = "ibl",
    opts = {},
  },
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },

  -- Diagnostics panel
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Defs / Refs (Trouble)",
      },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    },
    opts = {
      auto_close = true,
      focus = false,
    },
  },

  -- Format on save
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    opts = {
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
    },
  },

  -- Language syntax (lazy-loaded by filetype)
  { "neovimhaskell/haskell-vim", ft = "haskell" },
  { "whonore/Coqtail", ft = "coq" },
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
-- PLUGIN GLOBALS
-- ==============================================

-- PostgreSQL: prefer pgsql syntax for ambiguous .sql files
vim.g.sql_type_default = "pgsql"

-- Disable Copilot for very large files.
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

-- ==============================================
-- DIAGNOSTICS
-- ==============================================

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = { current_line = true },
  severity_sort = true,
  underline = true,
  update_in_insert = false,
})

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
    vim.keymap.set("n", "[d", function()
      vim.diagnostic.jump({ count = -1 })
    end, opts)
    vim.keymap.set("n", "]d", function()
      vim.diagnostic.jump({ count = 1 })
    end, opts)

    -- Inlay hints (rust-analyzer + others that support them)
    if vim.lsp.inlay_hint then
      pcall(vim.lsp.inlay_hint.enable, true, { bufnr = buf })
    end
  end,
})

-- Register blink.cmp completion capabilities for every LSP server.
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
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
