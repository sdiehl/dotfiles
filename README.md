# Dotfiles

[![CI](https://github.com/sdiehl/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/sdiehl/dotfiles/actions/workflows/ci.yml)

```bash
make brew           # Install Homebrew + Brewfile packages
make brew-dump      # Snapshot installed packages to Brewfile
make zsh            # Oh My Zsh + plugins + .zshrc
make git            # Symlink gitconfig (delta pager, LFS, credentials)
make nvim-config    # Symlink neovim config, colors, syntax files
make nvim-plugins   # Install neovim plugins (vim-plug)
make nvim-update    # Update neovim plugins
make ghostty        # Symlink Ghostty terminal config
make zed            # Symlink Zed settings
make starship       # Symlink Starship prompt config
make atuin          # Symlink Atuin shell history config
make ripgrep        # Symlink ripgrep config
make macos          # Set macOS defaults (key repeat, Finder, Dock)
make devenv         # Node (LTS), Rust (nightly), Lean 4, gh-dash
make obsidian       # Create DevBrain vault structure + plugin configs
make claude         # Connect Claude Code to Obsidian MCP
make codex          # Symlink Codex AGENTS.md + config.toml
make opencode       # Configure OpenCode MCP
make claude-config  # Symlink Claude Code config from DevBrain
make scripts        # Install ~/bin scripts (morning, eod)
make clean          # Remove all symlinks
```

```bash
./sync.sh           # Pull configs from local machine into repo
```

## Coding Agents

Agent configs (Claude Code, Codex, OpenCode) are managed here. Claude Code config
lives in `~/Documents/DevBrain/claude/` and is symlinked into `~/.claude/` via
`make claude-config`. Codex and OpenCode configs are symlinked directly from this repo.

All agents share read-only git rules, worktree conventions, and access to an
Obsidian knowledge graph via MCP (`make claude` / `make codex` / `make opencode`).

## Obsidian

```bash
make obsidian    # Create vault structure + copy plugin configs
```

Then in Obsidian: open `~/Documents/DevBrain`, enable Community Plugins, install
BRAT, add `aaronsb/obsidian-mcp-plugin`, enable Semantic MCP, copy API key.

```bash
export OBSIDIAN_MCP_KEY="your-key"  # Add to .zshrc
make claude                         # Connect Claude Code to vault
```
