export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(git extract git-extras rust 1password)

source $ZSH/oh-my-zsh.sh

eval "$(zoxide init zsh)"
alias j='z'

export LD_LIBRARY_PATH="${HOMEBREW_PREFIX}/lib${LD_LIBRARY_PATH:+:"${LD_LIBRARY_PATH}"}"
export PATH=/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH
export PATH=/opt/homebrew/opt/grep/libexec/gnubin:$PATH
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"

unsetopt beep

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

alias vim="nvim"
alias ls='ls --color'
alias pcr='pre-commit run --all-files'
alias pcp='pre-commit run --hook-stage pre-push --all-files'

alias codexs='codex resume --ask-for-approval never'
alias geminis='gemini --yolo'
alias claudes='claude --dangerously-skip-permissions'
alias opencodes='opencode --yolo'

zstyle ':omz:update' mode reminder
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# OCaml (optional)
[[ -r "$HOME/.opam/opam-init/init.zsh" ]] && source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2>&1

# Lean (optional)
[[ -r "$HOME/.elan/env" ]] && source "$HOME/.elan/env"

# LM Studio CLI (optional)
[[ -d "$HOME/.lmstudio/bin" ]] && export PATH="$PATH:$HOME/.lmstudio/bin"

# ccache
[[ -d "/opt/homebrew/opt/ccache/libexec" ]] && export PATH="$PATH:/opt/homebrew/opt/ccache/libexec"

# Work config (optional, not in repo)
[[ -r "$HOME/.zshrc_work" ]] && source "$HOME/.zshrc_work"
