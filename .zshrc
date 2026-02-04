# ==============================================
# OH-MY-ZSH
# ==============================================

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git extract git-extras rust 1password)
source $ZSH/oh-my-zsh.sh

zstyle ':omz:update' mode reminder
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# ==============================================
# PATH
# ==============================================

export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH=/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH
export PATH=/opt/homebrew/opt/grep/libexec/gnubin:$PATH
export PATH=/opt/homebrew/opt/llvm/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH

# ==============================================
# ENVIRONMENT
# ==============================================

export EDITOR='nvim'
export LD_LIBRARY_PATH="${HOMEBREW_PREFIX}/lib${LD_LIBRARY_PATH:+:"${LD_LIBRARY_PATH}"}"

unsetopt beep

# ==============================================
# ALIASES
# ==============================================

# Editor
alias vim='nvim'

# Utils
alias ls='ls --color'
alias j='z'
alias pcr='pre-commit run --all-files'
alias pcp='pre-commit run --hook-stage pre-push --all-files'

# AI tools (yolo mode)
alias claudes='claude --dangerously-skip-permissions'
alias codexs='codex --full-auto'
alias geminis='gemini --yolo'
alias opencodes='opencode --yolo'

# ==============================================
# TOOLS (optional, loaded if installed)
# ==============================================

# Zoxide
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# NVM
export NVM_DIR="$HOME/.nvm"
[[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]] && source "/opt/homebrew/opt/nvm/nvm.sh"

# OCaml
[[ -r "$HOME/.opam/opam-init/init.zsh" ]] && source "$HOME/.opam/opam-init/init.zsh" &>/dev/null

# Lean
[[ -r "$HOME/.elan/env" ]] && source "$HOME/.elan/env"

# LM Studio
[[ -d "$HOME/.lmstudio/bin" ]] && export PATH="$PATH:$HOME/.lmstudio/bin"

# ccache
[[ -d "/opt/homebrew/opt/ccache/libexec" ]] && export PATH="$PATH:/opt/homebrew/opt/ccache/libexec"

# ==============================================
# LOCAL CONFIG (not in repo)
# ==============================================

[[ -r "$HOME/.zshrc_work" ]] && source "$HOME/.zshrc_work"
[[ -r "$HOME/.zshrc_local" ]] && source "$HOME/.zshrc_local"
