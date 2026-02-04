# Makefile for macOS Development Setup
# Usage: make all (or individual targets)

DOTFILES_DIR := $(shell pwd)
HOME_DIR := $(HOME)
CONFIG_DIR := $(HOME)/.config

.PHONY: all brew configs nvim zsh git ghostty zed clean help

# =============================================================================
# Main Targets
# =============================================================================

## Full setup: install packages and configure everything
all: brew configs nvim-plugins
	@echo "Setup complete!"
	@echo ""
	@echo "Post-install steps:"
	@echo "  1. Run 'nvim' and execute ':Copilot setup' for GitHub Copilot"
	@echo "  2. Log into 1Password CLI: 'op signin'"
	@echo "  3. Restart your terminal to load zsh config"

## Install Homebrew and all packages from Brewfile
brew: brew-install brew-bundle

## Symlink all configuration files
configs: zsh git nvim ghostty zed
	@echo "All configs symlinked!"

# =============================================================================
# Homebrew
# =============================================================================

brew-install:
	@echo "Checking for Homebrew..."
	@which brew > /dev/null || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	@echo "Homebrew installed!"

brew-bundle:
	@echo "Installing packages from Brewfile..."
	@brew bundle install --file=$(DOTFILES_DIR)/Brewfile
	@echo "Packages installed!"

brew-dump:
	@echo "Dumping current packages to Brewfile..."
	@brew bundle dump --force --file=$(DOTFILES_DIR)/Brewfile
	@echo "Brewfile updated!"

# =============================================================================
# Shell Configuration
# =============================================================================

zsh:
	@echo "Setting up Zsh configuration..."
	@# Install oh-my-zsh if not present
	@if [ ! -d "$(HOME_DIR)/.oh-my-zsh" ]; then \
		echo "Installing oh-my-zsh..."; \
		sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; \
	fi
	@# Backup existing .zshrc if it's not a symlink
	@if [ -f "$(HOME_DIR)/.zshrc" ] && [ ! -L "$(HOME_DIR)/.zshrc" ]; then \
		echo "Backing up existing .zshrc to .zshrc.backup"; \
		mv "$(HOME_DIR)/.zshrc" "$(HOME_DIR)/.zshrc.backup"; \
	fi
	@rm -f $(HOME_DIR)/.zshrc
	@ln -sf $(DOTFILES_DIR)/.zshrc $(HOME_DIR)/.zshrc
	@echo "Zsh configured!"

# =============================================================================
# Git Configuration
# =============================================================================

git:
	@echo "Setting up Git configuration..."
	@rm -f $(HOME_DIR)/.gitconfig
	@ln -sf $(DOTFILES_DIR)/gitconfig $(HOME_DIR)/.gitconfig
	@echo "Git configured!"

# =============================================================================
# Neovim Configuration
# =============================================================================

NVIM_CONFIG_DIR := $(CONFIG_DIR)/nvim

nvim: nvim-config nvim-plugins
	@echo "Neovim setup complete!"

nvim-config:
	@echo "Setting up Neovim configuration..."
	@mkdir -p $(NVIM_CONFIG_DIR)
	@mkdir -p $(NVIM_CONFIG_DIR)/autoload
	@mkdir -p $(NVIM_CONFIG_DIR)/colors
	@mkdir -p $(NVIM_CONFIG_DIR)/syntax
	@# Remove existing files/symlinks
	@rm -f $(NVIM_CONFIG_DIR)/init.vim
	@rm -f $(NVIM_CONFIG_DIR)/autoload/plug.vim
	@rm -f $(NVIM_CONFIG_DIR)/colors/jellybeans.vim
	@rm -f $(NVIM_CONFIG_DIR)/syntax/lean.vim
	@# Create symlinks
	@ln -sf $(DOTFILES_DIR)/nvim/init.vim $(NVIM_CONFIG_DIR)/init.vim
	@ln -sf $(DOTFILES_DIR)/nvim/autoload/plug.vim $(NVIM_CONFIG_DIR)/autoload/plug.vim
	@if [ -f "$(DOTFILES_DIR)/nvim/colors/jellybeans.vim" ]; then \
		ln -sf $(DOTFILES_DIR)/nvim/colors/jellybeans.vim $(NVIM_CONFIG_DIR)/colors/jellybeans.vim; \
	fi
	@if [ -f "$(DOTFILES_DIR)/nvim/syntax/lean.vim" ]; then \
		ln -sf $(DOTFILES_DIR)/nvim/syntax/lean.vim $(NVIM_CONFIG_DIR)/syntax/lean.vim; \
	fi
	@echo "Neovim configuration symlinked!"

nvim-plugins:
	@echo "Installing Neovim plugins..."
	@nvim --headless +PlugInstall +qa 2>/dev/null || true
	@echo "Neovim plugins installed!"

nvim-update:
	@echo "Updating Neovim plugins..."
	@nvim --headless +PlugUpdate +qa 2>/dev/null || true
	@echo "Neovim plugins updated!"

nvim-clean:
	@echo "Removing Neovim configuration..."
	@rm -rf $(NVIM_CONFIG_DIR)
	@echo "Neovim configuration removed!"

# =============================================================================
# Ghostty Configuration
# =============================================================================

GHOSTTY_CONFIG_DIR := $(CONFIG_DIR)/ghostty

ghostty:
	@echo "Setting up Ghostty configuration..."
	@mkdir -p $(GHOSTTY_CONFIG_DIR)
	@rm -f $(GHOSTTY_CONFIG_DIR)/config
	@ln -sf $(DOTFILES_DIR)/ghostty/config $(GHOSTTY_CONFIG_DIR)/config
	@echo "Ghostty configured!"

# =============================================================================
# Zed Configuration
# =============================================================================

ZED_CONFIG_DIR := $(CONFIG_DIR)/zed

zed:
	@echo "Setting up Zed configuration..."
	@mkdir -p $(ZED_CONFIG_DIR)
	@rm -f $(ZED_CONFIG_DIR)/settings.json
	@ln -sf $(DOTFILES_DIR)/zed/settings.json $(ZED_CONFIG_DIR)/settings.json
	@echo "Zed configured!"

# =============================================================================
# macOS Defaults
# =============================================================================

macos-defaults:
	@echo "Setting macOS defaults..."
	@# Faster key repeat
	defaults write NSGlobalDomain KeyRepeat -int 2
	defaults write NSGlobalDomain InitialKeyRepeat -int 15
	@# Show hidden files in Finder
	defaults write com.apple.finder AppleShowAllFiles -bool true
	@# Show path bar in Finder
	defaults write com.apple.finder ShowPathbar -bool true
	@# Disable press-and-hold for keys (enable key repeat)
	defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
	@# Save screenshots to Downloads
	defaults write com.apple.screencapture location -string "$(HOME)/Downloads"
	@echo "macOS defaults set! Some changes require logout/restart."

# =============================================================================
# Cleanup
# =============================================================================

clean:
	@echo "Removing symlinks..."
	@rm -f $(HOME_DIR)/.zshrc
	@rm -f $(HOME_DIR)/.gitconfig
	@rm -rf $(NVIM_CONFIG_DIR)
	@rm -rf $(GHOSTTY_CONFIG_DIR)
	@rm -f $(ZED_CONFIG_DIR)/settings.json
	@echo "Symlinks removed!"

# =============================================================================
# Help
# =============================================================================

help:
	@echo "macOS Development Setup"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Main targets:"
	@echo "  all             Full setup (brew + configs + plugins)"
	@echo "  brew            Install Homebrew and all packages"
	@echo "  configs         Symlink all configuration files"
	@echo ""
	@echo "Individual configs:"
	@echo "  zsh             Setup Zsh with oh-my-zsh"
	@echo "  git             Symlink git configuration"
	@echo "  nvim            Setup Neovim (config + plugins)"
	@echo "  ghostty         Setup Ghostty terminal"
	@echo "  zed             Setup Zed editor"
	@echo ""
	@echo "Homebrew:"
	@echo "  brew-install    Install Homebrew"
	@echo "  brew-bundle     Install packages from Brewfile"
	@echo "  brew-dump       Update Brewfile from current packages"
	@echo ""
	@echo "Neovim:"
	@echo "  nvim-config     Symlink Neovim configuration"
	@echo "  nvim-plugins    Install vim-plug plugins"
	@echo "  nvim-update     Update vim-plug plugins"
	@echo "  nvim-clean      Remove Neovim configuration"
	@echo ""
	@echo "Other:"
	@echo "  macos-defaults  Set recommended macOS defaults"
	@echo "  clean           Remove all symlinks"
	@echo "  help            Show this help message"
