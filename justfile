# macOS Development Setup
# Bootstrap: make (installs just, then delegates here)
#
# Usage:
#   just          -- shell + editor essentials only (alias for: just basic)
#   just basic    -- shell + editor essentials only
#   just full     -- everything
#   just <recipe> -- run a specific recipe (see: just --list)

dotfiles := justfile_directory()
config := env("HOME") / ".config"
zsh_custom := env("HOME") / ".oh-my-zsh/custom/plugins"
vault := env("HOME") / "Documents/DevBrain"
lean_full := env("LEAN_FULL", "false")

# Toolchain versions (bump here)
python_version := "3.14"
node_version := "24"
rust_channel := "nightly"
lean_toolchain := "leanprover/lean4:stable"

# Default: alias for basic (shell + editor essentials)
default: basic

# Basic: install + configure shell and editor essentials
basic: brew-essentials zsh git nvim starship ripgrep lean4

# Full: packages, all configs, devenv, AI tooling, macOS, scripts
full: brew configs nvim-plugins macos devenv obsidian ai scripts

# --- Package management ---

# Minimal packages for shell + editor
brew-essentials:
    @which brew > /dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    @brew install neovim starship ripgrep git-delta zoxide fzf fd bat coreutils grep 2>/dev/null || true

# Full Brewfile (all packages, casks, fonts, apps)
brew:
    @which brew > /dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    @brew bundle install --file={{dotfiles}}/Brewfile

brew-dump:
    @brew bundle dump --force --file={{dotfiles}}/Brewfile

# --- Config symlinking ---

# All configs (shell, editor, AI)
configs: zsh git ssh nvim-config ghostty zed starship atuin ripgrep claude codex opencode

zsh:
    @[ -d "$HOME/.oh-my-zsh" ] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    @[ -d "{{zsh_custom}}/zsh-autosuggestions" ] || git clone https://github.com/zsh-users/zsh-autosuggestions {{zsh_custom}}/zsh-autosuggestions
    @[ -d "{{zsh_custom}}/zsh-syntax-highlighting" ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting {{zsh_custom}}/zsh-syntax-highlighting
    @ln -sf {{dotfiles}}/.zshrc $HOME/.zshrc

git:
    @ln -sf {{dotfiles}}/gitconfig $HOME/.gitconfig

# Neovim: config symlinks and plugin sync
nvim: nvim-config nvim-plugins

# Neovim: config symlinks only
nvim-config:
    @mkdir -p {{config}}/nvim/{syntax,ftdetect}
    @rm -f {{config}}/nvim/init.vim
    @rm -f {{config}}/nvim/colors/jellybeans.vim
    @ln -sf {{dotfiles}}/nvim/init.lua {{config}}/nvim/init.lua
    @ln -sfn {{dotfiles}}/nvim/lua {{config}}/nvim/lua
    @ln -sf {{dotfiles}}/nvim/lazy-lock.json {{config}}/nvim/lazy-lock.json
    @[ -f "{{dotfiles}}/nvim/syntax/lean.vim" ] && ln -sf {{dotfiles}}/nvim/syntax/lean.vim {{config}}/nvim/syntax/ || true
    @[ -f "{{dotfiles}}/nvim/syntax/koka.vim" ] && ln -sf {{dotfiles}}/nvim/syntax/koka.vim {{config}}/nvim/syntax/ || true
    @[ -f "{{dotfiles}}/nvim/ftdetect/koka.vim" ] && ln -sf {{dotfiles}}/nvim/ftdetect/koka.vim {{config}}/nvim/ftdetect/ || true
    @rm -f {{config}}/nvim/autoload/plug.vim 2>/dev/null || true
    @rmdir {{config}}/nvim/autoload 2>/dev/null || true

# Parser list mirrors `ensure_installed` in nvim/lua/plugins.lua. Keep in sync.
ts_parsers := "python rust lua vim vimdoc json yaml toml markdown markdown_inline haskell sql bash dockerfile regex query comment bibtex typst"

nvim-plugins:
    @nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
    @nvim --headless "+Lazy load nvim-treesitter" "+silent! TSInstallSync {{ts_parsers}}" +qa 2>/dev/null || true

nvim-update:
    @nvim --headless "+Lazy! update" +qa 2>/dev/null || true
    @nvim --headless "+Lazy load nvim-treesitter" "+silent! TSUpdateSync" +qa 2>/dev/null || true

ghostty:
    @mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
    @ln -sf {{dotfiles}}/ghostty/config "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

zed:
    @mkdir -p {{config}}/zed
    @ln -sf {{dotfiles}}/zed/settings.json {{config}}/zed/settings.json

starship:
    @mkdir -p {{config}}
    @ln -sf {{dotfiles}}/starship.toml {{config}}/starship.toml

atuin:
    @mkdir -p {{config}}/atuin
    @ln -sf {{dotfiles}}/atuin/config.toml {{config}}/atuin/config.toml

ripgrep:
    @ln -sf {{dotfiles}}/ripgreprc $HOME/.ripgreprc

ssh:
    @mkdir -p $HOME/.ssh
    @chmod 700 $HOME/.ssh
    @ln -sf {{dotfiles}}/ssh/config $HOME/.ssh/config

# --- macOS defaults ---

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
    @defaults write com.apple.dock mru-spaces -bool false
    @defaults write com.apple.screencapture location -string "$HOME/Downloads"
    @defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
    @defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
    @defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
    @killall Finder Dock 2>/dev/null || true

# --- Development environment ---

devenv: lean4 python-tools
    @mkdir -p $HOME/.nvm
    @export NVM_DIR="$HOME/.nvm" && . /opt/homebrew/opt/nvm/nvm.sh && nvm install {{node_version}}
    @rustup default {{rust_channel}}
    @rustup component add rust-analyzer clippy rustfmt
    @gh extension install dlvhdr/gh-dash 2>/dev/null || true

# Lean4 toolchain: elan, lean, lake, leanc
lean4:
    @[ -f "$HOME/.elan/bin/elan" ] || curl -sSf https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh | sh -s -- -y
    @$HOME/.elan/bin/elan default {{lean_toolchain}}
    @[ "{{lean_full}}" = "true" ] && $HOME/.elan/bin/lake exe cache get || true

# Python via uv (latest stable)
python-tools:
    @which uv > /dev/null || { echo "uv not found. Run 'just brew' first."; exit 1; }
    @uv python install {{python_version}}
    @echo "Installing Python {{python_version}} CLI tools via uv..."
    @uv tool install --python {{python_version}} black || true
    @uv tool install --python {{python_version}} huggingface-hub || true
    @uv tool install --python {{python_version}} jpterm || true
    @uv tool install --python {{python_version}} nbconvert || true
    @uv tool install --python {{python_version}} nbpreview || true
    @uv tool install --python {{python_version}} parquet-tools || true
    @echo "Python tools installed"

# --- Obsidian ---

obsidian:
    @echo "Setting up Obsidian vault..."
    @mkdir -p {{vault}}/{formal-methods,rust,onechronos,scratch,daily}
    @mkdir -p {{vault}}/.obsidian/plugins
    @cp {{dotfiles}}/obsidian/community-plugins.json {{vault}}/.obsidian/ 2>/dev/null || true
    @cp {{dotfiles}}/obsidian/core-plugins.json {{vault}}/.obsidian/ 2>/dev/null || true
    @cp {{dotfiles}}/obsidian/app.json {{vault}}/.obsidian/ 2>/dev/null || true
    @cp {{dotfiles}}/obsidian/appearance.json {{vault}}/.obsidian/ 2>/dev/null || true
    @echo "NOTE: Install plugins via Obsidian GUI:"
    @echo "  1. Enable community plugins"
    @echo "  2. Install BRAT, add: aaronsb/obsidian-mcp-plugin"
    @echo "  3. Configure API key in Semantic MCP settings"

# --- AI tooling ---

# AI setup: MCP servers, plugins, and config for all AI tools
ai: claude codex opencode

# Claude Code: MCP servers, plugins, and DevBrain config
claude:
    #!/usr/bin/env bash
    echo "Setting up Claude Code..."
    # MCP servers and plugins (skip if claude CLI not installed)
    if command -v claude &>/dev/null; then
        claude mcp add lean-lsp --scope user -- uvx lean-lsp-mcp 2>/dev/null || true
        echo "Claude Code: Lean LSP MCP configured"
        claude plugin marketplace add cameronfreer/lean4-skills 2>/dev/null || true
        claude plugin install lean4@lean4-skills 2>/dev/null || true
        echo "Claude Code: lean4-skills plugin installed"
        if [ -n "$OBSIDIAN_MCP_KEY" ]; then
            claude mcp add obsidian --scope user -- npx mcp-remote http://localhost:3001/mcp --header "Authorization: Bearer $OBSIDIAN_MCP_KEY" 2>/dev/null || true
            echo "Claude Code: Obsidian MCP configured"
        else
            echo "Set OBSIDIAN_MCP_KEY env var to configure Obsidian MCP"
        fi
    else
        echo "Claude CLI not found, skipping MCP/plugin setup"
    fi
    # DevBrain config (settings, CLAUDE.md, skills, commands, rules, hooks)
    if [ ! -d "{{vault}}/claude" ]; then
        echo "DevBrain not found at {{vault}}/claude, skipping config symlinks"
    else
        mkdir -p $HOME/.claude/rules $HOME/.claude/hooks $HOME/.claude/skills
        ln -sf {{vault}}/claude/settings.json $HOME/.claude/settings.json
        ln -sf {{vault}}/claude/CLAUDE.md $HOME/.claude/CLAUDE.md
        ln -sf {{vault}}/claude/rules/onechronos.md $HOME/.claude/rules/onechronos.md
        ln -sf {{vault}}/claude/hooks/session-end.sh $HOME/.claude/hooks/session-end.sh
        chmod +x {{vault}}/claude/hooks/session-end.sh
        for skill in {{vault}}/claude/skills/*/; do
            ln -sfn "$skill" $HOME/.claude/skills/"$(basename "$skill")"
        done
        ln -sfn {{vault}}/claude/commands $HOME/.claude/commands
        echo "Claude Code: DevBrain config linked"
    fi

# Codex: config symlinks
codex:
    @mkdir -p $HOME/.codex
    @ln -sf {{dotfiles}}/codex/AGENTS.md $HOME/.codex/AGENTS.md
    @ln -sf {{dotfiles}}/codex/config.toml $HOME/.codex/config.toml
    @echo "Codex: config linked"

# OpenCode: config symlinks
opencode:
    @mkdir -p {{config}}/opencode
    @ln -sf {{dotfiles}}/opencode/opencode.json {{config}}/opencode/opencode.json
    @echo "OpenCode: config linked"

# --- Scripts ---

scripts:
    @echo "Installing scripts..."
    @mkdir -p $HOME/bin
    @ln -sf {{dotfiles}}/bin/lib-common.sh $HOME/bin/lib-common.sh
    @ln -sf {{dotfiles}}/bin/morning $HOME/bin/morning
    @ln -sf {{dotfiles}}/bin/eod $HOME/bin/eod
    @chmod +x $HOME/bin/morning $HOME/bin/eod 2>/dev/null || true
    @echo "Installed: lib-common.sh, morning, eod"

# --- Cleanup ---

clean:
    @rm -f $HOME/.zshrc $HOME/.gitconfig $HOME/.ripgreprc
    @rm -rf {{config}}/nvim {{config}}/atuin
    @rm -f "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
    @rm -f {{config}}/zed/settings.json {{config}}/starship.toml
