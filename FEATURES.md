# Features

## Shell (Zsh)

**Oh-My-Zsh Plugins:**

- `git` - Git aliases (gst, gco, gp, etc.)
- `extract` - Extract any archive with `x`
- `git-extras` - Additional git commands
- `rust` - Rust/cargo completions
- `zsh-autosuggestions` - Fish-like suggestions
- `zsh-syntax-highlighting` - Command highlighting

**Prompt (Starship):**

- Git branch and status
- Language versions (Rust, Python, Node, Lua)
- Command duration (>2s)

**History (Atuin):**

- SQLite-backed searchable history
- Fuzzy search with `Ctrl+R`
- Local-only (no sync)

**Worktree Management:**

- `wt` - Switch worktree (fzf)
- `wta <branch>` - Add worktree to `~/work/`
- `wtl` - List worktrees
- `wtr <path>` - Remove worktree
- `wts` - Status across all worktrees (dirty files, ahead/behind, sorted by recent commit)

**Aliases:**

- `vim` -> `nvim`
- `j` -> `zoxide` (smart cd)
- `pcr` / `pcp` - pre-commit run (all / pre-push)
- `gpp` - git push origin --no-verify
- `claudes`, `codexs`, `geminis`, `opencodes` - AI agents in yolo mode

## Neovim

Pure-Lua config. Entry point `nvim/init.lua` requires `lua/plugins.lua` and `lua/editor.lua`.
Leader key is Space. Local-leader is backslash.

**Colorscheme:**

- `metalelf0/jellybeans-nvim` - Lua port of jellybeans (covers tree-sitter capture groups)

**Core Plugins:**

- `copilot.lua` - GitHub Copilot (Lua port; Tab to accept, M-]/M-[ next/prev, C-] dismiss)
- `blink.cmp` - LSP completion engine (C-Space show, C-y accept, C-n/C-p navigate)
- `telescope.nvim` - Fuzzy finder (`Ctrl+P` files, `Ctrl+G` grep)
- `neo-tree.nvim` - File explorer (`Ctrl+N` toggle)
- `lualine.nvim` - Status line
- `vim-fugitive` - Git integration (`<leader>gd` diff, `gb` blame)
- `vim-easy-align` - Text alignment (`a=`, `a;`, `a,`, `a-` in visual mode)

**Editor Enhancements:**

- `nvim-treesitter` (master branch, locked for Nvim 0.11) - 20 parsers: python, rust, lua, vim, vimdoc, json, yaml, toml, markdown, markdown_inline, haskell, sql, bash, dockerfile, regex, query, comment, bibtex, typst, lean (Lean parser via `Julian/tree-sitter-lean` registered as custom; queries from helix-editor; LaTeX uses Neovim's built-in `tex` syntax)
- `gitsigns.nvim` - Git diff in gutter
- `Comment.nvim` - Toggle comments (`gcc`, `gc`)
- `nvim-autopairs` - Auto close brackets (treesitter-aware, no pairing in strings/comments)
- `indent-blankline.nvim` - Visual indent guides
- `which-key.nvim` - Keybinding hints
- `trouble.nvim` - Aggregated diagnostics panel (`<leader>xx` workspace, `<leader>xX` buffer, `<leader>cs` symbols)

**LSP (Language Server Protocol):**

- Native `vim.lsp.config` (Neovim 0.11+) with `rust-analyzer` (go-to-definition, hover, diagnostics, code actions)
- Clippy integration via `check.command = "clippy"`
- Inlay hints enabled on attach
- Diagnostics: virtual_lines on current line, no virtual_text spam
- blink.cmp completion capabilities advertised globally to all servers

**Format on save (conform.nvim):**

- Rust: nightly rustfmt (edition 2024)
- Markdown: dprint
- Python: black
- TOML: taplo
- JSON/YAML: prettier
- Shell: shfmt

**Lean:**

- `Julian/lean.nvim` - LSP + infoview (proof state); auto-opens on `.lean` files
- Custom `syntax/lean.vim` for highlighting

**Language Support:**

- `haskell-vim` - Haskell
- `Coqtail` - Coq
- `souffle.vim` - Souffle/Datalog
- `pgsql.vim` - PostgreSQL (default for `.sql`)
- Custom syntax: Lean, Koka

**Filetype detection:**

- `.kk` -> koka, `.dl` -> souffle, `.fp` -> haskell, `.lean` -> lean, `.typ` -> typst, `.v` -> coq (overrides Verilog default), `.ll` -> llvm, `.y` -> happy, `.x` -> alex

**Keybindings (leader = Space):**

- `Ctrl+P` - Find files
- `Ctrl+G` - Live grep
- `Ctrl+N` - Toggle file tree
- `Ctrl+J` - Switch windows
- `Ctrl+T` - New tab
- `tn/tp` - Next/prev tab
- `<leader>gd` - Git diff
- `gb` - Git blame

## CLI Tools

**Search:**

- `ripgrep` - Fast grep (with smart defaults via `~/.ripgreprc`)
- `fd` - Fast find (respects .gitignore)
- `fzf` - Fuzzy finder (files, history, branches), uses `fd` for file search and `bat` for preview
- `tokei` - Fast code statistics by language

**Git:**

- `gh` - GitHub CLI
- `gh dash` - PR/issues dashboard
- `git-lfs` - Large file storage
- `git-delta` - Syntax-aware diff pager (default for git diff, log, blame)
- `lazygit` - Terminal UI for git (worktree support, interactive staging)

**Data:**

- `jq` / `yq` - JSON/YAML processors
- `fx` - Interactive JSON viewer (terminal)
- `duckdb` - Analytical SQL engine (Parquet, CSV, JSON)

**Development:**

- `just` - Command runner
- `pre-commit` - Git hooks
- `bat` - Syntax-highlighted cat
- `btop`, `htop` - Process monitors
- `dprint` - Markdown/JSON formatter
- `taplo` - TOML formatter
- `shfmt` - Shell formatter
- `shellcheck` - Shell linter
- `llvm` - LLVM toolchain (clang, opt, llc, llvm-as, etc.)
- `tmux` - Terminal multiplexer (persistent sessions)
- `ncdu` - Interactive disk usage viewer
- `pv` - Pipe viewer (throughput/progress on any pipe)
- `watch` - Repeat a command every N seconds
- `wget` - HTTP downloader (recursive, resumable)

## Pre-commit Hooks (dotfiles)

- `trailing-whitespace` - Auto-fix trailing whitespace
- `end-of-file-fixer` - Ensure files end with newline
- `check-yaml` - Validate YAML syntax
- `check-json` - Validate JSON (obsidian configs)
- `check-merge-conflict` - Catch conflict markers
- `shfmt` - Auto-format shell scripts (4-space indent)
- `shellcheck` - Lint shell scripts
- `taplo fmt` - Auto-format TOML
- `dprint fmt` - Auto-format Markdown
- `stylua` - Auto-format Lua (Neovim config)
- `brewfile-syntax` - Validate Brewfile
- `justfile-check` - Validate justfile syntax

## Claude Code Config

All config lives in `~/Documents/DevBrain/claude/` (git-tracked, Obsidian-ignored)
and is symlinked into `~/.claude/` via `just claude-config`.

**Skills:** morning, eod, standup, weekly, sync

**Commands:** `/morning`, `/eod`, `/sync`

**Hooks:** session-end (appends timestamp to daily note)

**Rules:** CLAUDE.md (global), onechronos.md (work repos)

## Development Environments

**Node.js:**

- `nvm` - Version manager
- LTS installed by default

**Rust:**

- `rustup` - Toolchain manager
- Nightly default
- `rust-analyzer`, `clippy`, `rustfmt`
- `cargo-nextest` - Parallel test runner (replaces `cargo test`)
- `cargo-expand` - Macro expansion viewer (`cargo expand`)
- `cargo-insta` - Snapshot testing (`cargo insta review`)
- `cargo-machete` - Detect unused dependencies
- `cargo-flamegraph` - Generate flamegraphs from cargo runs
- `cargo-outdated` - Show outdated dependencies

**Lean 4:**

- `elan` - Version manager
- Stable toolchain
- Mathlib cache (optional)

**Python:**

- `uv` - Fast package manager
- `python@3.13` (via uv)
- `black` - Code formatter
- `huggingface-hub` - HuggingFace CLI (model downloads, repo management)
- `jpterm` - Jupyter notebooks in the terminal
- `nbconvert` - Notebook conversion (to HTML, PDF, Markdown, etc.)
- `nbpreview` - Terminal notebook previewer
- `parquet-tools` - Inspect and query Parquet files

**Other:**

- `z3` - SMT solver
- `openjdk` + `google-java-format`
- `tla-plus-toolbox` - TLA+
- `typst` - Document typesetting
- `texlive` - LaTeX

## macOS Settings

**Keyboard:**

- Fast key repeat
- Caps Lock -> Escape
- Disable press-and-hold

**Trackpad:**

- Natural scrolling disabled
- Two-finger right click
- Two-finger double tap

**Finder:**

- Show hidden files
- Show path bar
- Show status bar

**Dock:**

- Auto-hide
- Small icons (48px)

**Other:**

- Screenshots to ~/Downloads
- Disable auto-correct, auto-capitalize, auto-period

## Apps (Homebrew)

**Editors:**

- Ghostty (terminal)
- Zed
- Neovide
- Obsidian

**AI:**

- ChatGPT
- Claude Code
- Codex
- Gemini CLI
- OpenCode
- LM Studio

**Productivity:**

- Raycast
- 1Password CLI
- Caffeine

**Other:**

- Spotify
- VLC
- Scrivener
- gcloud CLI

## Fonts

- Fira Code
- Fira Sans
- Source Code Pro
- Computer Modern
