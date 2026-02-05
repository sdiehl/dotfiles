#!/bin/bash
# Sync dotfiles from local machine to this repo

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Syncing dotfiles from local machine..."

# Zsh
cp ~/.zshrc "$DOTFILES_DIR/.zshrc"

# Git
cp ~/.gitconfig "$DOTFILES_DIR/gitconfig"

# Neovim
cp ~/.config/nvim/init.vim "$DOTFILES_DIR/nvim/init.vim"
cp ~/.config/nvim/autoload/plug.vim "$DOTFILES_DIR/nvim/autoload/plug.vim"
cp ~/.config/nvim/colors/jellybeans.vim "$DOTFILES_DIR/nvim/colors/jellybeans.vim"
cp ~/.config/nvim/syntax/lean.vim "$DOTFILES_DIR/nvim/syntax/lean.vim" 2>/dev/null || true
cp ~/.config/nvim/syntax/koka.vim "$DOTFILES_DIR/nvim/syntax/koka.vim" 2>/dev/null || true
cp ~/.config/nvim/ftdetect/koka.vim "$DOTFILES_DIR/nvim/ftdetect/koka.vim" 2>/dev/null || true

# Ghostty
cp ~/.config/ghostty/config "$DOTFILES_DIR/ghostty/config"

# Zed
cp ~/.config/zed/settings.json "$DOTFILES_DIR/zed/settings.json"

# Starship
cp ~/.config/starship.toml "$DOTFILES_DIR/starship.toml" 2>/dev/null || true

# Atuin
cp ~/.config/atuin/config.toml "$DOTFILES_DIR/atuin/config.toml" 2>/dev/null || true

# Ripgrep
cp ~/.ripgreprc "$DOTFILES_DIR/ripgreprc" 2>/dev/null || true

# Brewfile
brew bundle dump --force --file="$DOTFILES_DIR/Brewfile"

# Obsidian (configs only, not plugin data with secrets)
VAULT="$HOME/Documents/DevBrain"
if [ -d "$VAULT/.obsidian" ]; then
    mkdir -p "$DOTFILES_DIR/obsidian"
    cp "$VAULT/.obsidian/community-plugins.json" "$DOTFILES_DIR/obsidian/" 2>/dev/null || true
    cp "$VAULT/.obsidian/core-plugins.json" "$DOTFILES_DIR/obsidian/" 2>/dev/null || true
    cp "$VAULT/.obsidian/app.json" "$DOTFILES_DIR/obsidian/" 2>/dev/null || true
    cp "$VAULT/.obsidian/appearance.json" "$DOTFILES_DIR/obsidian/" 2>/dev/null || true
fi

# Claude Code memory
if [ -d "$HOME/.claude" ]; then
    mkdir -p "$DOTFILES_DIR/claude/rules"
    cp "$HOME/.claude/CLAUDE.md" "$DOTFILES_DIR/claude/CLAUDE.md" 2>/dev/null || true
    cp "$HOME/.claude/rules/"*.md "$DOTFILES_DIR/claude/rules/" 2>/dev/null || true
fi

# Codex
if [ -d "$HOME/.codex" ]; then
    mkdir -p "$DOTFILES_DIR/codex"
    cp "$HOME/.codex/AGENTS.md" "$DOTFILES_DIR/codex/AGENTS.md" 2>/dev/null || true
    cp "$HOME/.codex/config.toml" "$DOTFILES_DIR/codex/config.toml" 2>/dev/null || true
fi

echo "Done. Review changes with: git diff"
