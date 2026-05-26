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
      -- Force Full text-sync: dodges the nvim 0.12 incremental-sync
      -- assert in vim/lsp/sync.lua:136 that fires when Copilot's LSP
      -- client tracks markdown / fast edits.
      server_opts_overrides = {
        flags = { allow_incremental_sync = false },
      },
      should_attach = function()
        local name = vim.api.nvim_buf_get_name(0)
        local size = vim.fn.getfsize(name)
        if size > 100000 or size == -2 then
          return false
        end
        return true
      end,
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

  -- Alignment
  {
    "echasnovski/mini.align",
    version = false,
    keys = { { "ga", mode = { "n", "x" } }, { "gA", mode = { "n", "x" } } },
    config = function()
      require("mini.align").setup()
    end,
  },

  -- Treesitter (main branch: supported on Nvim 0.10+, required on 0.12)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- Register Julian/tree-sitter-lean via the User TSUpdate hook.
      -- `install()` calls `reload_parsers()` which clears
      -- `package.loaded['nvim-treesitter.parsers']` and fires this autocmd
      -- right after, so any inline assignment beforehand is wiped.
      vim.api.nvim_create_autocmd("User", {
        pattern = "TSUpdate",
        callback = function()
          require("nvim-treesitter.parsers").lean = {
            install_info = {
              url = "https://github.com/Julian/tree-sitter-lean",
              files = { "src/parser.c", "src/scanner.c" },
              branch = "main",
            },
          }
        end,
      })

      require("nvim-treesitter").setup({
        install_dir = vim.fn.stdpath("data") .. "/site",
      })

      require("nvim-treesitter").install({
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
        "bibtex",
        "typst",
        "lean",
      })

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          local lang = vim.treesitter.language.get_lang(ft) or ft
          pcall(vim.treesitter.start, args.buf, lang)
        end,
      })
    end,
  },

  -- Treesitter textobjects (main branch: keymaps registered manually)
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local select = require("nvim-treesitter-textobjects.select").select_textobject
      for _, m in ipairs({
        { "af", "@function.outer" },
        { "if", "@function.inner" },
        { "ac", "@class.outer" },
        { "ic", "@class.inner" },
        { "aa", "@parameter.outer" },
        { "ia", "@parameter.inner" },
      }) do
        vim.keymap.set({ "x", "o" }, m[1], function()
          select(m[2], "textobjects")
        end)
      end

      local move = require("nvim-treesitter-textobjects.move")
      local mode = { "n", "x", "o" }
      for _, m in ipairs({
        { "]m", "goto_next_start", "@function.outer" },
        { "]]", "goto_next_start", "@class.outer" },
        { "]M", "goto_next_end", "@function.outer" },
        { "][", "goto_next_end", "@class.outer" },
        { "[m", "goto_previous_start", "@function.outer" },
        { "[[", "goto_previous_start", "@class.outer" },
        { "[M", "goto_previous_end", "@function.outer" },
        { "[]", "goto_previous_end", "@class.outer" },
      }) do
        vim.keymap.set(mode, m[1], function()
          move[m[2]](m[3], "textobjects")
        end)
      end
    end,
  },

  -- Completion
  {
    "saghen/blink.cmp",
    lazy = false,
    version = "1.*",
    opts = {
      keymap = {
        preset = "default",
        ["<Tab>"] = {},
        ["<S-Tab>"] = {},
        ["<C-l>"] = { "snippet_forward", "fallback" },
        ["<C-h>"] = { "snippet_backward", "fallback" },
      },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        menu = { auto_show = true },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      snippets = { preset = "luasnip" },
      signature = { enabled = true },
    },
  },

  -- Snippet engine (drives blink.cmp's "snippets" source)
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },

  -- Editor enhancements
  { "lewis6991/gitsigns.nvim", event = "VeryLazy", opts = {} },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = { check_ts = true } },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    main = "ibl",
    opts = {},
  },
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },

  -- Motion
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        function()
          require("flash").jump()
        end,
        mode = { "n", "x", "o" },
        desc = "Flash",
      },
      {
        "S",
        function()
          require("flash").treesitter()
        end,
        mode = { "n", "x", "o" },
        desc = "Flash Treesitter",
      },
      {
        "r",
        function()
          require("flash").remote()
        end,
        mode = "o",
        desc = "Remote Flash",
      },
    },
  },

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
  { "souffle-lang/souffle.vim", ft = "souffle" },
  { "lifepillar/pgsql.vim", ft = { "sql", "pgsql" } },

  -- Lean: LSP + infoview (proof state)
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
  rocks = { enabled = false },
})

-- ==============================================
-- PLUGIN GLOBALS
-- ==============================================

-- PostgreSQL: prefer pgsql syntax for ambiguous .sql files
vim.g.sql_type_default = "pgsql"

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
      cargo = {
        allFeatures = true,
        buildScripts = { enable = true },
      },
      procMacro = { enable = true },
    },
  },
})
vim.lsp.enable("rust_analyzer")
