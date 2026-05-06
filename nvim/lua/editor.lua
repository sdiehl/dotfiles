-- Keymaps, autocmds, filetype detection, abbreviations, user commands.

-- ==============================================
-- KEYBINDINGS
-- ==============================================

vim.keymap.set("n", "q", "<Nop>")
vim.keymap.set("n", "<leader>/", [[/\c]])
vim.keymap.set("n", "<CR>", ":noh<CR>", { silent = true })

vim.keymap.set("n", "<C-j>", "<C-W>w")
vim.keymap.set("n", "`", "g;")
vim.keymap.set("n", "gl", "<C-^>")

vim.keymap.set("n", "<C-t>", ":tabnew<CR>")
vim.keymap.set("n", "tn", ":tabnext<CR>")
vim.keymap.set("n", "tp", ":tabprevious<CR>")

vim.keymap.set("", "<F12>", ":wincmd =<CR>", { silent = true })

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])

-- ==============================================
-- AUTOCOMMANDS
-- ==============================================

local windows_grp = vim.api.nvim_create_augroup("sd_windows", { clear = true })
vim.api.nvim_create_autocmd("VimResized", {
  group = windows_grp,
  command = "wincmd =",
})
vim.api.nvim_create_autocmd("TermOpen", {
  group = windows_grp,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

local trailing_grp = vim.api.nvim_create_augroup("sd_trailing_whitespace", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = trailing_grp,
  pattern = { "*.py", "*.hs" },
  callback = function()
    vim.cmd([[silent! %s/\s\+$//e]])
    vim.cmd([[silent! %s/\(\s*\n\)\+\%$//e]])
  end,
})

-- ==============================================
-- FILETYPES
-- ==============================================

vim.filetype.add({
  extension = {
    y = "happy",
    x = "alex",
    agda = "agda",
    idr = "idris",
    ll = "llvm",
    fp = "haskell",
    dl = "souffle",
    lean = "lean",
    typ = "typst",
    v = "coq",
  },
})

local filetypes_grp = vim.api.nvim_create_augroup("sd_filetypes", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  group = filetypes_grp,
  pattern = { "*.rst", "*.txt", "*.tex", "*.latex", "*.md", "*.typ" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.number = false
  end,
})

-- ==============================================
-- ABBREVIATIONS
-- ==============================================

vim.cmd("abbreviate teh the")
vim.cmd("abbreviate sefl self")
vim.cmd("abbreviate equivelant equivalent")

-- ==============================================
-- USER COMMANDS
-- ==============================================

vim.api.nvim_create_user_command("Flush", function()
  vim.cmd([[!find . -name '.*.swp' | xargs rm -f]])
end, {})

vim.api.nvim_create_user_command("Wipeout", function()
  local buffers = vim.fn.range(1, vim.fn.bufnr("$"))
  local current_tab = vim.fn.tabpagenr()
  local ok, err = pcall(function()
    for _ = 1, vim.fn.tabpagenr("$") do
      for win = 1, vim.fn.winnr("$") do
        local buf = vim.fn.winbufnr(win)
        for i, b in ipairs(buffers) do
          if b == buf then
            table.remove(buffers, i)
            break
          end
        end
      end
    end
    if #buffers > 0 then
      local strs = {}
      for _, b in ipairs(buffers) do strs[#strs + 1] = tostring(b) end
      vim.cmd("bwipeout " .. table.concat(strs, " "))
    end
  end)
  vim.cmd("tabnext " .. current_tab)
  if not ok then error(err) end
end, {})
