# Makefile for setting up Neovim on a clean macOS install
# Usage: make nvim

DOTFILES_DIR := $(shell pwd)
NVIM_CONFIG_DIR := $(HOME)/.config/nvim

.PHONY: nvim nvim-deps nvim-brew nvim-node nvim-config nvim-plugins nvim-clean

# Main target: full Neovim setup
nvim: nvim-deps nvim-config nvim-plugins
	@echo "Neovim setup complete!"
	@echo "Run 'nvim' and execute ':Copilot setup' to configure GitHub Copilot"

# Install all dependencies
nvim-deps: nvim-brew nvim-node

# Install Homebrew and Neovim
nvim-brew:
	@echo "Checking for Homebrew..."
	@which brew > /dev/null || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	@echo "Installing Neovim..."
	@brew install neovim || true
	@echo "Installing optional dependencies..."
	@brew install ripgrep fd || true

# Install Node.js via nvm (required for Copilot)
nvim-node:
	@echo "Checking for nvm..."
	@if [ ! -d "$(HOME)/.nvm" ]; then \
		echo "Installing nvm..."; \
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash; \
	fi
	@echo "Installing Node.js..."
	@export NVM_DIR="$(HOME)/.nvm" && \
		[ -s "$$NVM_DIR/nvm.sh" ] && . "$$NVM_DIR/nvm.sh" && \
		nvm install --lts || true

# Symlink Neovim configuration
nvim-config:
	@echo "Setting up Neovim configuration..."
	@mkdir -p $(NVIM_CONFIG_DIR)
	@mkdir -p $(NVIM_CONFIG_DIR)/autoload
	@mkdir -p $(NVIM_CONFIG_DIR)/colors
	@mkdir -p $(NVIM_CONFIG_DIR)/syntax
	@# Remove existing files/symlinks if they exist
	@rm -f $(NVIM_CONFIG_DIR)/init.vim
	@rm -f $(NVIM_CONFIG_DIR)/autoload/plug.vim
	@rm -f $(NVIM_CONFIG_DIR)/colors/jellybeans.vim
	@rm -f $(NVIM_CONFIG_DIR)/syntax/lean.vim
	@# Create symlinks
	@ln -sf $(DOTFILES_DIR)/nvim/init.vim $(NVIM_CONFIG_DIR)/init.vim
	@ln -sf $(DOTFILES_DIR)/nvim/autoload/plug.vim $(NVIM_CONFIG_DIR)/autoload/plug.vim
	@ln -sf $(DOTFILES_DIR)/nvim/colors/jellybeans.vim $(NVIM_CONFIG_DIR)/colors/jellybeans.vim
	@ln -sf $(DOTFILES_DIR)/nvim/syntax/lean.vim $(NVIM_CONFIG_DIR)/syntax/lean.vim
	@echo "Configuration symlinked to $(NVIM_CONFIG_DIR)"

# Install vim-plug plugins
nvim-plugins:
	@echo "Installing Neovim plugins..."
	@nvim --headless +PlugInstall +qa 2>/dev/null || true
	@echo "Plugins installed"

# Remove Neovim configuration (for clean reinstall)
nvim-clean:
	@echo "Removing Neovim configuration..."
	@rm -rf $(NVIM_CONFIG_DIR)
	@echo "Configuration removed"

# Help target
help:
	@echo "Neovim Setup Makefile"
	@echo ""
	@echo "Targets:"
	@echo "  make nvim          - Full setup (deps + config + plugins)"
	@echo "  make nvim-deps     - Install dependencies only (brew, node)"
	@echo "  make nvim-brew     - Install Homebrew and Neovim"
	@echo "  make nvim-node     - Install nvm and Node.js"
	@echo "  make nvim-config   - Symlink configuration files"
	@echo "  make nvim-plugins  - Install vim-plug plugins"
	@echo "  make nvim-clean    - Remove Neovim configuration"
