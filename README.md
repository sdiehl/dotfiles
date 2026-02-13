# Dotfiles

[![CI](https://github.com/sdiehl/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/sdiehl/dotfiles/actions/workflows/ci.yml)

## Setup

Bootstrap installs `just` (if missing) then runs all recipes:

```bash
make                # Bootstrap: installs just, then runs `just all`
```

After first run, use `just` directly:

```bash
just brew           # Install Homebrew + Brewfile packages
just brew-dump      # Snapshot installed packages to Brewfile
just zsh            # Oh My Zsh + plugins + .zshrc
just git            # Symlink gitconfig (delta pager, LFS, credentials)
just nvim-config    # Symlink neovim config, colors, syntax files
just nvim-plugins   # Install neovim plugins (Lazy.nvim)
just nvim-update    # Update neovim plugins
just ghostty        # Symlink Ghostty terminal config
just zed            # Symlink Zed settings
just starship       # Symlink Starship prompt config
just atuin          # Symlink Atuin shell history config
just ripgrep        # Symlink ripgrep config
just macos          # Set macOS defaults (key repeat, Finder, Dock)
just devenv         # Node (LTS), Rust (nightly), Lean 4, gh-dash
just obsidian       # Create DevBrain vault structure + plugin configs
just claude         # Connect Claude Code to Obsidian MCP
just codex          # Symlink Codex AGENTS.md + config.toml
just opencode       # Configure OpenCode MCP
just claude-config  # Symlink Claude Code config from DevBrain
just scripts        # Install ~/bin scripts (morning, eod)
just clean          # Remove all symlinks
```

```bash
./sync.sh           # Pull configs from local machine into repo
```

## Coding Agents

Agent configs (Claude Code, Codex, OpenCode) are managed here. Claude Code config
lives in `~/Documents/DevBrain/claude/` and is symlinked into `~/.claude/` via
`just claude-config`. Codex and OpenCode configs are symlinked directly from this repo.

All agents share read-only git rules, worktree conventions, and access to an
Obsidian knowledge graph via MCP (`just claude` / `just codex` / `just opencode`).

## Obsidian

```bash
just obsidian    # Create vault structure + copy plugin configs
```

Then in Obsidian: open `~/Documents/DevBrain`, enable Community Plugins, install
BRAT, add `aaronsb/obsidian-mcp-plugin`, enable Semantic MCP, copy API key.

```bash
export OBSIDIAN_MCP_KEY="your-key"  # Add to .zshrc
just claude                         # Connect Claude Code to vault
```

With ❤️ from Stephen
