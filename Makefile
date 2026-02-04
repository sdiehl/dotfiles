# macOS Development Setup

DOTFILES := $(shell pwd)
CONFIG := $(HOME)/.config

.PHONY: all brew configs zsh git nvim ghostty zed macos devenv clean

all: brew configs nvim-plugins macos devenv

brew:
	@which brew > /dev/null || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	@brew bundle install --file=$(DOTFILES)/Brewfile

brew-dump:
	@brew bundle dump --force --file=$(DOTFILES)/Brewfile

configs: zsh git nvim-config ghostty zed

zsh:
	@[ -d "$(HOME)/.oh-my-zsh" ] || sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	@ln -sf $(DOTFILES)/.zshrc $(HOME)/.zshrc

git:
	@ln -sf $(DOTFILES)/gitconfig $(HOME)/.gitconfig

nvim: nvim-config nvim-plugins

nvim-config:
	@mkdir -p $(CONFIG)/nvim/{autoload,colors,syntax}
	@ln -sf $(DOTFILES)/nvim/init.vim $(CONFIG)/nvim/init.vim
	@ln -sf $(DOTFILES)/nvim/autoload/plug.vim $(CONFIG)/nvim/autoload/plug.vim
	@[ -f "$(DOTFILES)/nvim/colors/jellybeans.vim" ] && ln -sf $(DOTFILES)/nvim/colors/jellybeans.vim $(CONFIG)/nvim/colors/ || true
	@[ -f "$(DOTFILES)/nvim/syntax/lean.vim" ] && ln -sf $(DOTFILES)/nvim/syntax/lean.vim $(CONFIG)/nvim/syntax/ || true

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

macos:
	@# Keyboard
	@defaults write NSGlobalDomain KeyRepeat -int 2
	@defaults write NSGlobalDomain InitialKeyRepeat -int 15
	@defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
	@hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029}]}' > /dev/null
	@# Trackpad
	@defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
	@defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
	@defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool false
	@defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 1
	@defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
	@# Finder
	@defaults write com.apple.finder AppleShowAllFiles -bool true
	@defaults write com.apple.finder ShowPathbar -bool true
	@defaults write com.apple.finder ShowStatusBar -bool true
	@# Dock
	@defaults write com.apple.dock autohide -bool true
	@defaults write com.apple.dock tilesize -int 48
	@# Screenshots
	@defaults write com.apple.screencapture location -string "$(HOME)/Downloads"
	@# Typing
	@defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
	@defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
	@defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
	@killall Finder Dock 2>/dev/null || true

devenv:
	@# Node (nvm)
	@mkdir -p $(HOME)/.nvm
	@. /opt/homebrew/opt/nvm/nvm.sh && nvm install --lts
	@# Rust
	@rustup default nightly
	@rustup component add rust-analyzer clippy rustfmt
	@# Lean4
	@command -v elan > /dev/null || curl -sSf https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh | sh -s -- -y
	@elan default leanprover/lean4:stable

clean:
	@rm -f $(HOME)/.zshrc $(HOME)/.gitconfig
	@rm -rf $(CONFIG)/nvim $(CONFIG)/ghostty
	@rm -f $(CONFIG)/zed/settings.json
