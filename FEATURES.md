# Features

## Shell (Zsh)

**Oh-My-Zsh Plugins:**

- `git` - Git aliases (gst, gco, gp, etc.)
- `extract` - Extract any archive with `x`
- `git-extras` - Additional git commands
- `rust` - Rust/cargo completions
- `1password` - 1Password CLI completions
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

**Core Plugins:**

- `copilot.vim` - GitHub Copilot
- `telescope.nvim` - Fuzzy finder (`Ctrl+P` files, `Ctrl+G` grep)
- `neo-tree.nvim` - File explorer (`Ctrl+N` toggle)
- `vim-airline` - Status line
- `vim-fugitive` - Git integration (`gd` diff, `gb` blame)
- `tabular` - Text alignment (`a=`, `a;`, `a,`, `a-`)

**Editor Enhancements:**

- `nvim-treesitter` - Syntax highlighting
- `gitsigns.nvim` - Git diff in gutter
- `Comment.nvim` - Toggle comments (`gcc`, `gc`)
- `nvim-autopairs` - Auto close brackets
- `indent-blankline.nvim` - Visual indent guides
- `which-key.nvim` - Keybinding hints

**Language Support:**

- `haskell-vim` - Haskell
- `rust.vim` - Rust
- `Coqtail` - Coq
- `agda-vim` - Agda
- `idris2-vim` - Idris 2
- `souffle.vim` - Souffle/Datalog
- `pgsql.vim` - PostgreSQL
- Custom syntax: Lean, Koka, Typst

**Keybindings:**

- `Ctrl+P` - Find files
- `Ctrl+G` - Live grep
- `Ctrl+N` - Toggle file tree
- `Ctrl+J` - Switch windows
- `Ctrl+T` - New tab
- `tn/tp` - Next/prev tab
- `gd` - Git diff
- `gb` - Git blame

## CLI Tools

**Search:**

- `ripgrep` - Fast grep (with smart defaults via `~/.ripgreprc`)
- `fd` - Fast find (respects .gitignore)
- `fzf` - Fuzzy finder (files, history, branches)
- `the_silver_searcher` - ag

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

**Lean 4:**

- `elan` - Version manager
- Stable toolchain
- Mathlib cache (optional)

**Python:**

- `uv` - Fast package manager
- `python@3.14`
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
- Amethyst (tiling)
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
