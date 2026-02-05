# ==============================================
# OH-MY-ZSH
# ==============================================

export ZSH="$HOME/.oh-my-zsh"
plugins=(git extract git-extras rust 1password zsh-autosuggestions zsh-syntax-highlighting)
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
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export WORKTREE_ROOT="$HOME/work"

# MCP Server Keys (Obsidian knowledge graph)
export OBSIDIAN_MCP_KEY="6b2b3198e07829e4f56a89b7789044ce3eb028e00fd59d2f09d0bc82efebe0ba"

# GitHub MCP (read-only access for agents)
export GITHUB_TOKEN="$(security find-generic-password -a $USER -s github-token -w 2>/dev/null)"

unsetopt beep

# ==============================================
# ALIASES
# ==============================================

alias vim='nvim'
alias ls='ls --color'
alias j='z'
alias pcr='pre-commit run --all-files'
alias pcp='pre-commit run --hook-stage pre-push --all-files'

alias claudes='claude --dangerously-skip-permissions'
alias codexs='codex --full-auto'
alias geminis='gemini --yolo'
alias opencodes='opencode --yolo'

# ==============================================
# WORKTREE MANAGEMENT
# ==============================================

wt() {
  local repo=$(basename $(git rev-parse --show-toplevel 2>/dev/null))
  [[ -z "$repo" ]] && echo "Not in a git repo" && return 1
  local worktrees=$(git worktree list | tail -n +2 | awk '{print $1}')
  [[ -z "$worktrees" ]] && echo "No worktrees" && return 1
  local selected=$(echo "$worktrees" | fzf --prompt="Switch worktree: ")
  [[ -n "$selected" ]] && cd "$selected"
}

wta() {
  local repo=$(basename $(git rev-parse --show-toplevel 2>/dev/null))
  [[ -z "$repo" ]] && echo "Not in a git repo" && return 1
  local branch=$1
  [[ -z "$branch" ]] && echo "Usage: wta <branch>" && return 1
  mkdir -p "$WORKTREE_ROOT"
  git worktree add "$WORKTREE_ROOT/$repo-$branch" "$branch" 2>/dev/null || \
  git worktree add -b "$branch" "$WORKTREE_ROOT/$repo-$branch"
  cd "$WORKTREE_ROOT/$repo-$branch"
}

wtl() { git worktree list; }

wtr() {
  local path=$1
  [[ -z "$path" ]] && echo "Usage: wtr <path>" && return 1
  git worktree remove "$path"
}

# ==============================================
# TOOLS
# ==============================================

command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"
command -v starship &>/dev/null && eval "$(starship init zsh)"
command -v atuin &>/dev/null && eval "$(atuin init zsh)"

export NVM_DIR="$HOME/.nvm"
[[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]] && source "/opt/homebrew/opt/nvm/nvm.sh"

[[ -r "$HOME/.opam/opam-init/init.zsh" ]] && source "$HOME/.opam/opam-init/init.zsh" &>/dev/null

[[ -r "$HOME/.elan/env" ]] && source "$HOME/.elan/env"

[[ -d "$HOME/.lmstudio/bin" ]] && export PATH="$PATH:$HOME/.lmstudio/bin"

[[ -d "/opt/homebrew/opt/ccache/libexec" ]] && export PATH="$PATH:/opt/homebrew/opt/ccache/libexec"

# ==============================================
# LOCAL CONFIG (not in repo)
# ==============================================

[[ -r "$HOME/.zshrc_work" ]] && source "$HOME/.zshrc_work"
[[ -r "$HOME/.zshrc_local" ]] && source "$HOME/.zshrc_local"
