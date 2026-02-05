# macOS Development Setup

DOTFILES := $(shell pwd)
CONFIG := $(HOME)/.config
ZSH_CUSTOM := $(HOME)/.oh-my-zsh/custom/plugins

.PHONY: all brew configs zsh git nvim ghostty zed starship atuin ripgrep macos devenv obsidian claude clean

all: brew configs nvim-plugins macos devenv obsidian claude

brew:
	@which brew > /dev/null || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	@brew bundle install --file=$(DOTFILES)/Brewfile

brew-dump:
	@brew bundle dump --force --file=$(DOTFILES)/Brewfile

configs: zsh git nvim-config ghostty zed starship atuin ripgrep claude-memory

zsh:
	@[ -d "$(HOME)/.oh-my-zsh" ] || sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	@[ -d "$(ZSH_CUSTOM)/zsh-autosuggestions" ] || git clone https://github.com/zsh-users/zsh-autosuggestions $(ZSH_CUSTOM)/zsh-autosuggestions
	@[ -d "$(ZSH_CUSTOM)/zsh-syntax-highlighting" ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting $(ZSH_CUSTOM)/zsh-syntax-highlighting
	@ln -sf $(DOTFILES)/.zshrc $(HOME)/.zshrc

git:
	@ln -sf $(DOTFILES)/gitconfig $(HOME)/.gitconfig

nvim: nvim-config nvim-plugins

nvim-config:
	@mkdir -p $(CONFIG)/nvim/{autoload,colors,syntax,ftdetect}
	@ln -sf $(DOTFILES)/nvim/init.vim $(CONFIG)/nvim/init.vim
	@ln -sf $(DOTFILES)/nvim/autoload/plug.vim $(CONFIG)/nvim/autoload/plug.vim
	@[ -f "$(DOTFILES)/nvim/colors/jellybeans.vim" ] && ln -sf $(DOTFILES)/nvim/colors/jellybeans.vim $(CONFIG)/nvim/colors/ || true
	@[ -f "$(DOTFILES)/nvim/syntax/lean.vim" ] && ln -sf $(DOTFILES)/nvim/syntax/lean.vim $(CONFIG)/nvim/syntax/ || true
	@[ -f "$(DOTFILES)/nvim/syntax/koka.vim" ] && ln -sf $(DOTFILES)/nvim/syntax/koka.vim $(CONFIG)/nvim/syntax/ || true
	@[ -f "$(DOTFILES)/nvim/ftdetect/koka.vim" ] && ln -sf $(DOTFILES)/nvim/ftdetect/koka.vim $(CONFIG)/nvim/ftdetect/ || true

nvim-plugins:
	@nvim --headless +PlugInstall +qa 2>/dev/null || true

nvim-update:
	@nvim --headless +PlugUpdate +qa 2>/dev/null || true

ghostty:
	@mkdir -p $(CONFIG)/ghostty
	@ln -sf $(DOTFILES)/ghostty/config $(CONFIG)/ghostty/config

zed:
	@mkdir -p $(CONFIG)/zed
	@ln -sf $(DOTFILES)/zed/settings.json $(CONFIG)/zed/settings.json

starship:
	@mkdir -p $(CONFIG)
	@ln -sf $(DOTFILES)/starship.toml $(CONFIG)/starship.toml

atuin:
	@mkdir -p $(CONFIG)/atuin
	@ln -sf $(DOTFILES)/atuin/config.toml $(CONFIG)/atuin/config.toml

ripgrep:
	@ln -sf $(DOTFILES)/ripgreprc $(HOME)/.ripgreprc

claude-memory:
	@mkdir -p $(HOME)/.claude/rules
	@ln -sf $(DOTFILES)/claude/CLAUDE.md $(HOME)/.claude/CLAUDE.md
	@ln -sf $(DOTFILES)/claude/rules/onechronos.md $(HOME)/.claude/rules/onechronos.md

macos:
	@defaults write NSGlobalDomain KeyRepeat -int 2
	@defaults write NSGlobalDomain InitialKeyRepeat -int 15
	@defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
	@hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029}]}' > /dev/null
	@defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
	@defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
	@defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool false
	@defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 1
	@defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
	@defaults write com.apple.finder AppleShowAllFiles -bool true
	@defaults write com.apple.finder ShowPathbar -bool true
	@defaults write com.apple.finder ShowStatusBar -bool true
	@defaults write com.apple.dock autohide -bool true
	@defaults write com.apple.dock tilesize -int 48
	@defaults write com.apple.screencapture location -string "$(HOME)/Downloads"
	@defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
	@defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
	@defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
	@killall Finder Dock 2>/dev/null || true

LEAN_FULL ?= true

devenv:
	@mkdir -p $(HOME)/.nvm
	@. /opt/homebrew/opt/nvm/nvm.sh && nvm install --lts
	@rustup default nightly
	@rustup component add rust-analyzer clippy rustfmt
	@[ -f "$(HOME)/.elan/bin/elan" ] || curl -sSf https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh | sh -s -- -y
	@$(HOME)/.elan/bin/elan default leanprover/lean4:stable
	@[ "$(LEAN_FULL)" = "true" ] && $(HOME)/.elan/bin/lake exe cache get || true
	@gh extension install dlvhdr/gh-dash 2>/dev/null || true

VAULT := $(HOME)/Documents/DevBrain

obsidian:
	@echo "Setting up Obsidian vault..."
	@mkdir -p $(VAULT)/{formal-methods,rust,onechronos,scratch,daily}
	@mkdir -p $(VAULT)/.obsidian/plugins
	@cp $(DOTFILES)/obsidian/community-plugins.json $(VAULT)/.obsidian/ 2>/dev/null || true
	@cp $(DOTFILES)/obsidian/core-plugins.json $(VAULT)/.obsidian/ 2>/dev/null || true
	@cp $(DOTFILES)/obsidian/app.json $(VAULT)/.obsidian/ 2>/dev/null || true
	@cp $(DOTFILES)/obsidian/appearance.json $(VAULT)/.obsidian/ 2>/dev/null || true
	@echo "NOTE: Install plugins via Obsidian GUI:"
	@echo "  1. Enable community plugins"
	@echo "  2. Install BRAT, add: aaronsb/obsidian-mcp-plugin"
	@echo "  3. Configure API key in Semantic MCP settings"

claude:
	@echo "Setting up Claude Code MCP servers..."
	@if [ -n "$$OBSIDIAN_MCP_KEY" ]; then \
		claude mcp add obsidian --scope user -- npx mcp-remote http://localhost:3001/mcp --header "Authorization: Bearer $$OBSIDIAN_MCP_KEY" 2>/dev/null || true; \
		echo "Claude Code: Obsidian MCP configured"; \
	else \
		echo "Set OBSIDIAN_MCP_KEY env var to configure Claude Code MCP"; \
	fi

opencode:
	@echo "Setting up OpenCode MCP servers..."
	@mkdir -p $(CONFIG)/opencode
	@if [ -n "$$OBSIDIAN_MCP_KEY" ]; then \
		echo '{"$$schema":"https://opencode.ai/config.json","mcp":{"obsidian":{"type":"remote","url":"http://localhost:3001/mcp","headers":{"Authorization":"Bearer '$$OBSIDIAN_MCP_KEY'"}}}}' > $(CONFIG)/opencode/opencode.json; \
		echo "OpenCode: Obsidian MCP configured"; \
	else \
		echo "Set OBSIDIAN_MCP_KEY env var to configure OpenCode MCP"; \
	fi

clean:
	@rm -f $(HOME)/.zshrc $(HOME)/.gitconfig $(HOME)/.ripgreprc
	@rm -rf $(CONFIG)/nvim $(CONFIG)/ghostty $(CONFIG)/atuin
	@rm -f $(CONFIG)/zed/settings.json $(CONFIG)/starship.toml
