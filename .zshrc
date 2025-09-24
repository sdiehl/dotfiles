ZSH_THEME="robbyrussell"
export ZSH="$HOME/.oh-my-zsh"

alias vim="nvim"
alias ls='ls --color'
alias pcr='pre-commit run --all-files'
alias pcp='pre-commit run --hook-stage pre-push --all-files'

alias claudes='claude --dangerously-skip-permissions'
alias zed="open -a /Applications/Zed.app -n"

zstyle ':omz:update' mode reminder

plugins=(git extract git-extras ubuntu rust 1password)

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

alias ls='ls --color'

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

[[ ! -r '/Users/sdiehl/.opam/opam-init/init.zsh' ]] || source '/Users/sdiehl/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null

eval "$(zoxide init zsh)"
alias j='z'

export LD_LIBRARY_PATH="${HOMEBREW_PREFIX}/lib${LD_LIBRARY_PATH:+:"${LD_LIBRARY_PATH}"}"
export PATH=/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH
export PATH=/opt/homebrew/opt/grep/libexec/gnubin:$PATH
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"

unsetopt beep

export RUSTFLAGS='-L opt/mock_exegy'

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

source /Users/sdiehl/.zshrc_work
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export PATH="/opt/homebrew/opt/llvm@20/bin:$PATH"
export LIBRARY_PATH="/opt/homebrew/opt/zstd/lib:$LIBRARY_PATH"
