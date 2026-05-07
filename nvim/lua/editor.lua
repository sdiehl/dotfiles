-- Keymaps, autocmds, filetype detection, abbreviations, user commands.

-- ==============================================
-- KEYBINDINGS
-- ==============================================

-- Disable cmdline-window pop-up (q:, q/, q?) but keep macro recording.
vim.keymap.set("n", "q:", "<Nop>")
vim.keymap.set("n", "q/", "<Nop>")
vim.keymap.set("n", "q?", "<Nop>")
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
    local view = vim.fn.winsaveview()
    vim.cmd([[silent! %s/\s\+$//e]])
    vim.cmd([[silent! %s/\(\s*\n\)\+\%$//e]])
    vim.fn.winrestview(view)
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

-- Wipe every buffer that isn't visible in any window across all tabs.
vim.api.nvim_create_user_command("Wipeout", function()
  local visible = {}
  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
      visible[vim.api.nvim_win_get_buf(win)] = true
    end
  end
  local victims = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and not visible[buf] then
      victims[#victims + 1] = buf
    end
  end
  if #victims > 0 then
    vim.cmd("bwipeout " .. table.concat(victims, " "))
  end
end, {})
