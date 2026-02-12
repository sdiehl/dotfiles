#!/bin/bash
# Sync dotfiles from local machine to this repo

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Syncing dotfiles from local machine..."

# Helper: copy file only if not already symlinked to destination
sync_file() {
    local src="$1"
    local dst="$2"
    if [ -L "$src" ]; then
        local target
        target=$(readlink "$src")
        if [ "$target" = "$dst" ] || [ "$target" = "$(cd "$(dirname "$dst")" && pwd)/$(basename "$dst")" ]; then
            return 0 # Already symlinked, skip
        fi
    fi
    cp "$src" "$dst"
}

# Zsh
sync_file ~/.zshrc "$DOTFILES_DIR/.zshrc"

# Git
sync_file ~/.gitconfig "$DOTFILES_DIR/gitconfig"

# Neovim
sync_file ~/.config/nvim/init.vim "$DOTFILES_DIR/nvim/init.vim"
sync_file ~/.config/nvim/lazy-lock.json "$DOTFILES_DIR/nvim/lazy-lock.json"
sync_file ~/.config/nvim/colors/jellybeans.vim "$DOTFILES_DIR/nvim/colors/jellybeans.vim"
cp ~/.config/nvim/syntax/lean.vim "$DOTFILES_DIR/nvim/syntax/lean.vim" 2>/dev/null || true
cp ~/.config/nvim/syntax/koka.vim "$DOTFILES_DIR/nvim/syntax/koka.vim" 2>/dev/null || true
cp ~/.config/nvim/ftdetect/koka.vim "$DOTFILES_DIR/nvim/ftdetect/koka.vim" 2>/dev/null || true

# Ghostty
sync_file ~/.config/ghostty/config "$DOTFILES_DIR/ghostty/config"

# Zed
sync_file ~/.config/zed/settings.json "$DOTFILES_DIR/zed/settings.json"

# Starship
sync_file ~/.config/starship.toml "$DOTFILES_DIR/starship.toml"

# Atuin
sync_file ~/.config/atuin/config.toml "$DOTFILES_DIR/atuin/config.toml"

# Ripgrep
sync_file ~/.ripgreprc "$DOTFILES_DIR/ripgreprc"

# Brewfile
brew bundle dump --force --file="$DOTFILES_DIR/Brewfile"

# Obsidian (configs only, not plugin data with secrets)
VAULT="$HOME/Documents/DevBrain"
if [ -d "$VAULT/.obsidian" ]; then
    mkdir -p "$DOTFILES_DIR/obsidian"
    for json in community-plugins.json core-plugins.json app.json appearance.json daily-notes.json; do
        if [ -f "$VAULT/.obsidian/$json" ]; then
            jq '.' "$VAULT/.obsidian/$json" >"$DOTFILES_DIR/obsidian/$json"
        fi
    done
fi

# OpenCode
sync_file ~/.config/opencode/opencode.json "$DOTFILES_DIR/opencode/opencode.json"

# Claude Code config lives in DevBrain now (~/Documents/DevBrain/claude/)
# ~/.claude/ files are symlinks into DevBrain -- nothing to sync here.

# Codex
if [ -d "$HOME/.codex" ]; then
    mkdir -p "$DOTFILES_DIR/codex"
    cp "$HOME/.codex/AGENTS.md" "$DOTFILES_DIR/codex/AGENTS.md" 2>/dev/null || true
    cp "$HOME/.codex/config.toml" "$DOTFILES_DIR/codex/config.toml" 2>/dev/null || true
fi

# Scripts
mkdir -p "$DOTFILES_DIR/bin"
cp "$HOME/bin/morning" "$DOTFILES_DIR/bin/morning" 2>/dev/null || true
cp "$HOME/bin/eod" "$DOTFILES_DIR/bin/eod" 2>/dev/null || true

# Auto-format synced files for CI
if command -v taplo &>/dev/null; then
    taplo fmt "$DOTFILES_DIR" 2>/dev/null || true
fi

echo "Done. Review changes with: git diff"
