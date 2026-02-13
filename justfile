# macOS Development Setup
# Bootstrap: make (installs just, then delegates here)

dotfiles := justfile_directory()
config := env("HOME") / ".config"
zsh_custom := env("HOME") / ".oh-my-zsh/custom/plugins"
vault := env("HOME") / "Documents/DevBrain"
lean_full := env("LEAN_FULL", "true")

default: all

all: brew configs nvim-plugins macos devenv obsidian claude codex scripts claude-config

# --- Package management ---

brew:
    @which brew > /dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    @brew bundle install --file={{dotfiles}}/Brewfile

brew-dump:
    @brew bundle dump --force --file={{dotfiles}}/Brewfile

# --- Config symlinking ---

configs: zsh git nvim-config ghostty zed starship atuin ripgrep aerospace claude-config

zsh:
    @[ -d "$HOME/.oh-my-zsh" ] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    @[ -d "{{zsh_custom}}/zsh-autosuggestions" ] || git clone https://github.com/zsh-users/zsh-autosuggestions {{zsh_custom}}/zsh-autosuggestions
    @[ -d "{{zsh_custom}}/zsh-syntax-highlighting" ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting {{zsh_custom}}/zsh-syntax-highlighting
    @ln -sf {{dotfiles}}/.zshrc $HOME/.zshrc

git:
    @ln -sf {{dotfiles}}/gitconfig $HOME/.gitconfig

nvim: nvim-config nvim-plugins

nvim-config:
    @mkdir -p {{config}}/nvim/{colors,syntax,ftdetect}
    @ln -sf {{dotfiles}}/nvim/init.vim {{config}}/nvim/init.vim
    @ln -sf {{dotfiles}}/nvim/lazy-lock.json {{config}}/nvim/lazy-lock.json
    @[ -f "{{dotfiles}}/nvim/colors/jellybeans.vim" ] && ln -sf {{dotfiles}}/nvim/colors/jellybeans.vim {{config}}/nvim/colors/ || true
    @[ -f "{{dotfiles}}/nvim/syntax/lean.vim" ] && ln -sf {{dotfiles}}/nvim/syntax/lean.vim {{config}}/nvim/syntax/ || true
    @[ -f "{{dotfiles}}/nvim/syntax/koka.vim" ] && ln -sf {{dotfiles}}/nvim/syntax/koka.vim {{config}}/nvim/syntax/ || true
    @[ -f "{{dotfiles}}/nvim/ftdetect/koka.vim" ] && ln -sf {{dotfiles}}/nvim/ftdetect/koka.vim {{config}}/nvim/ftdetect/ || true
    @rm -f {{config}}/nvim/autoload/plug.vim 2>/dev/null || true
    @rmdir {{config}}/nvim/autoload 2>/dev/null || true

nvim-plugins:
    @nvim --headless "+Lazy! sync" +qa 2>/dev/null || true

nvim-update:
    @nvim --headless "+Lazy! update" +qa 2>/dev/null || true

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

aerospace:
    @ln -sf {{dotfiles}}/aerospace.toml $HOME/.aerospace.toml

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

devenv: python-tools
    @mkdir -p $HOME/.nvm
    @export NVM_DIR="$HOME/.nvm" && . /opt/homebrew/opt/nvm/nvm.sh && nvm install --lts
    @rustup default nightly
    @rustup component add rust-analyzer clippy rustfmt
    @[ -f "$HOME/.elan/bin/elan" ] || curl -sSf https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh | sh -s -- -y
    @$HOME/.elan/bin/elan default leanprover/lean4:stable
    @[ "{{lean_full}}" = "true" ] && $HOME/.elan/bin/lake exe cache get || true
    @gh extension install dlvhdr/gh-dash 2>/dev/null || true

python-tools:
    @which uv > /dev/null || { echo "uv not found. Run 'just brew' first."; exit 1; }
    @echo "Installing Python CLI tools via uv..."
    @uv tool install black
    @uv tool install huggingface-hub
    @uv tool install jpterm
    @uv tool install nbconvert
    @uv tool install nbpreview
    @uv tool install parquet-tools
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

claude:
    #!/usr/bin/env bash
    echo "Setting up Claude Code MCP servers..."
    claude mcp add lean-lsp --scope user -- uvx lean-lsp-mcp 2>/dev/null || true
    echo "Claude Code: Lean LSP MCP configured"
    claude plugin marketplace add cameronfreer/lean4-skills 2>/dev/null || true
    claude plugin install lean4@lean4-skills 2>/dev/null || true
    echo "Claude Code: lean4-skills plugin installed"
    if [ -n "$OBSIDIAN_MCP_KEY" ]; then
        claude mcp add obsidian --scope user -- npx mcp-remote http://localhost:3001/mcp --header "Authorization: Bearer $OBSIDIAN_MCP_KEY" 2>/dev/null || true
        echo "Claude Code: Obsidian MCP configured"
    else
        echo "Set OBSIDIAN_MCP_KEY env var to configure Claude Code MCP"
    fi

opencode:
    @echo "Setting up OpenCode..."
    @mkdir -p {{config}}/opencode
    @ln -sf {{dotfiles}}/opencode/opencode.json {{config}}/opencode/opencode.json
    @echo "OpenCode: config linked"

codex:
    @echo "Setting up Codex..."
    @mkdir -p $HOME/.codex
    @ln -sf {{dotfiles}}/codex/AGENTS.md $HOME/.codex/AGENTS.md
    @ln -sf {{dotfiles}}/codex/config.toml $HOME/.codex/config.toml
    @echo "Codex: AGENTS.md and config.toml linked"

# --- Scripts ---

scripts:
    @echo "Installing scripts..."
    @mkdir -p $HOME/bin
    @ln -sf {{dotfiles}}/bin/morning $HOME/bin/morning
    @ln -sf {{dotfiles}}/bin/eod $HOME/bin/eod
    @chmod +x $HOME/bin/morning $HOME/bin/eod 2>/dev/null || true
    @echo "Installed: morning, eod"

# --- Claude Code config from DevBrain ---

claude-config:
    #!/usr/bin/env bash
    if [ ! -d "{{vault}}/claude" ]; then
        echo "DevBrain not found at {{vault}}/claude -- skipping claude-config"
    else
        echo "Symlinking Claude Code config from DevBrain..."
        mkdir -p $HOME/.claude/rules $HOME/.claude/hooks $HOME/.claude/skills
        ln -sf {{vault}}/claude/settings.json $HOME/.claude/settings.json
        ln -sf {{vault}}/claude/CLAUDE.md $HOME/.claude/CLAUDE.md
        ln -sf {{vault}}/claude/rules/onechronos.md $HOME/.claude/rules/onechronos.md
        ln -sf {{vault}}/claude/hooks/session-end.sh $HOME/.claude/hooks/session-end.sh
        chmod +x {{vault}}/claude/hooks/session-end.sh
        for skill in morning eod standup weekly sync review; do
            ln -sfn {{vault}}/claude/skills/$skill $HOME/.claude/skills/$skill
        done
        ln -sfn {{vault}}/claude/commands $HOME/.claude/commands
        echo "Claude Code config linked from DevBrain ({{vault}}/claude/)"
    fi

# --- Cleanup ---

clean:
    @rm -f $HOME/.zshrc $HOME/.gitconfig $HOME/.ripgreprc $HOME/.aerospace.toml
    @rm -rf {{config}}/nvim {{config}}/atuin
    @rm -f "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
    @rm -f {{config}}/zed/settings.json {{config}}/starship.toml
