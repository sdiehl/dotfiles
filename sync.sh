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

# Ghostty
cp ~/.config/ghostty/config "$DOTFILES_DIR/ghostty/config"

# Zed
cp ~/.config/zed/settings.json "$DOTFILES_DIR/zed/settings.json"

# Brewfile
brew bundle dump --force --file="$DOTFILES_DIR/Brewfile"

echo "Done. Review changes with: git diff"
