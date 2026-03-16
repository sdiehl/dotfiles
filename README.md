# Dotfiles

[![CI](https://github.com/sdiehl/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/sdiehl/dotfiles/actions/workflows/ci.yml)

## Install

```bash
make        # bootstrap: installs just, then runs default (shell + editor)
```

This installs the minimal packages (neovim, starship, ripgrep, delta, zoxide,
fzf, fd, bat) and symlinks zsh, git, neovim, starship, and ripgrep configs.

For everything (full Brewfile, all configs, devenv, macOS defaults, AI tooling):

```bash
just all
```

## Recipes

```
just brew-essentials  Minimal brew packages for shell + editor
just brew             Full Brewfile (all packages, casks, fonts, apps)
just brew-dump        Snapshot installed packages to Brewfile
just zsh              Oh My Zsh + plugins + .zshrc
just git              Symlink gitconfig (delta, LFS, credentials)
just nvim             Neovim config + plugins
just nvim-update      Update neovim plugins
just ghostty          Ghostty terminal config
just zed              Zed editor settings
just starship         Starship prompt config
just atuin            Atuin shell history config
just ripgrep          Ripgrep config
just macos            macOS defaults (key repeat, Finder, Dock)
just devenv           Node (LTS), Rust (nightly), Lean 4, gh-dash
just python-tools     Python CLI tools via uv
just obsidian         DevBrain vault structure + plugin configs
just ai               All AI agent configs (Claude, Codex, OpenCode)
just scripts          ~/bin scripts (morning, eod)
just clean            Remove all symlinks
```

```bash
./sync.sh             # pull configs from local machine into repo
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
export OBSIDIAN_MCP_KEY="your-key"  # Add to .zshrc_local
just claude                         # Connect Claude Code to vault
```

With ❤️ from Stephen
