# Dotfiles

[![CI](https://github.com/sdiehl/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/sdiehl/dotfiles/actions/workflows/ci.yml)

## Install

```bash
make        # bootstrap: installs just, then runs default (shell + editor)
```

This installs the minimal packages (neovim, starship, ripgrep, delta, zoxide,
fzf, fd, bat) and symlinks zsh, git, neovim, starship, and ripgrep configs.

## Everything

```bash
just all    # full Brewfile, all configs, devenv, macOS defaults, AI tooling
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

## Sync

```bash
./sync.sh   # pull configs from local machine into repo
```
