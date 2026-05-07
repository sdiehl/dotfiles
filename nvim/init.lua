-- Stephen Diehl init.lua

-- Must be set before any <leader> mapping is registered.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- ==============================================
-- LAZY.NVIM BOOTSTRAP
-- ==============================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specs and plugin-specific configuration.
require("plugins")

-- ==============================================
-- SETTINGS
-- ==============================================

vim.opt.number = true
vim.opt.wrap = false
vim.opt.showmode = false
vim.opt.showmatch = true
vim.opt.mouse = "a"
vim.opt.clipboard:append("unnamedplus")
vim.opt.textwidth = 80
vim.opt.cmdheight = 2
vim.opt.timeoutlen = 500
vim.opt.scrolloff = 8
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.smartindent = true
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.foldenable = false
vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

vim.opt.pumheight = 12
vim.opt.wildmode = { "longest", "list", "full" }
vim.opt.wildignore:append({ "*/tmp/*", "*.swp", "*.swo", "*.zip", ".git" })

vim.opt.termguicolors = true
-- Colorscheme is set by the jellybeans-nvim plugin's config callback (priority = 1000).

-- Keymaps, autocmds, filetypes, abbreviations, user commands.
require("editor")
