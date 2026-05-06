-- Stephen Diehl init.lua

-- ==============================================
-- LAZY.NVIM BOOTSTRAP
-- ==============================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specs and plugin-specific configuration.
require("plugins")

-- ==============================================
-- SETTINGS
-- ==============================================

vim.cmd("syntax on")
vim.cmd("filetype plugin indent on")

vim.opt.number = true
vim.opt.wrap = false
vim.opt.showmode = false
vim.opt.showmatch = true
vim.opt.conceallevel = 0
vim.opt.belloff = "all"
vim.opt.mouse = "a"
vim.opt.clipboard:append("unnamedplus")
vim.opt.textwidth = 80
vim.opt.cmdheight = 2
vim.opt.timeoutlen = 500

vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.foldenable = false
vim.opt.undofile = true

vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

vim.opt.pumheight = 12
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest", "list", "full" }
vim.opt.wildignore:append({ "*/tmp/*", "*.swp", "*.swo", "*.zip", ".git" })

vim.opt.termguicolors = true
vim.cmd.colorscheme("jellybeans")

-- Keymaps, autocmds, filetypes, abbreviations, user commands.
require("editor")
