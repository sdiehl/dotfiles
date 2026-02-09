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
alias gpp='git push origin --no-verify'

alias claudes='claude --dangerously-skip-permissions'
alias codexs='codex --full-auto'
alias geminis='gemini --yolo'
alias opencodes='opencode --yolo'

# ==============================================
# WORKTREE MANAGEMENT
# ==============================================
#
# Convention (monoclonal):
#   Bare repo:  ~/work/worktrees/monoclonal.git
#   Folders:    ~/work/worktrees/sdiehl-<name>
#   Branches:   sdiehl/<name>
#
# Functions:
#   wt          Switch worktree (fzf)
#   wta <name>  Create new worktree (sdiehl/<name> off origin/main)
#   wtp <branch> Pull remote branch into local worktree
#   wtl         List worktrees
#   wtr <path>  Remove worktree
#   wts         Status across all worktrees

WORKTREE_BARE="${WORKTREE_ROOT:-$HOME/work}/worktrees/monoclonal.git"

wt() {
  local root="${WORKTREE_ROOT:-$HOME/work}"
  local worktrees=$(find "$root" "$root/worktrees" -maxdepth 1 -type d 2>/dev/null | while read -r d; do
    [ -d "$d/.git" ] || [ -f "$d/.git" ] || continue
    echo "$d"
  done)
  [[ -z "$worktrees" ]] && echo "No worktrees found" && return 1
  local selected=$(echo "$worktrees" | fzf --prompt="Switch worktree: ")
  [[ -n "$selected" ]] && cd "$selected"
}

# Create new worktree: wta foo-bar -> sdiehl/foo-bar at ~/work/worktrees/sdiehl-foo-bar
wta() {
  local name=$1
  [[ -z "$name" ]] && echo "Usage: wta <name>" && return 1
  local branch="sdiehl/$name"
  local dir="${WORKTREE_ROOT:-$HOME/work}/worktrees/sdiehl-$name"
  [[ -d "$dir" ]] && echo "Already exists: $dir" && return 1
  git -C "$WORKTREE_BARE" fetch origin main
  git -C "$WORKTREE_BARE" worktree add -b "$branch" "$dir" origin/main
  cd "$dir"
}

# Pull a remote branch into a local worktree (for checking out other people's branches)
wtp() {
  local branch=$1
  [[ -z "$branch" ]] && echo "Usage: wtp <branch> (e.g. sdiehl/my-feature or max/his-feature)" && return 1
  local worktree_name="${branch##*/}"
  local dir="${WORKTREE_ROOT:-$HOME/work}/worktrees/$worktree_name"
  git -C "$WORKTREE_BARE" fetch origin --prune
  git -C "$WORKTREE_BARE" worktree prune
  if ! git -C "$WORKTREE_BARE" rev-parse --verify "origin/$branch" &>/dev/null; then
    echo "Branch '$branch' not found on origin" && return 1
  fi
  if [[ -d "$dir" ]]; then
    echo "Worktree exists, pulling: $dir"
    git -C "$dir" pull --ff-only || true
  else
    if git -C "$WORKTREE_BARE" show-ref --verify --quiet "refs/heads/$branch"; then
      git -C "$WORKTREE_BARE" worktree add "$dir" "$branch"
    else
      git -C "$WORKTREE_BARE" worktree add -b "$branch" "$dir" "origin/$branch"
    fi
    git -C "$dir" branch --set-upstream-to="origin/$branch" "$branch"
  fi
  echo "cd $dir"
}

wtl() { git -C "$WORKTREE_BARE" worktree list 2>/dev/null || git worktree list; }

wtr() {
  local path=$1
  [[ -z "$path" ]] && echo "Usage: wtr <path>" && return 1
  git -C "$WORKTREE_BARE" worktree remove "$path" 2>/dev/null || git worktree remove "$path"
}

# Status across all worktrees, sorted by most recent commit
wts() {
  local root="${WORKTREE_ROOT:-$HOME/work}"
  local rows=()
  local maxname=0 maxbranch=0
  for dir in "$root"/*/ "$root"/worktrees/*/; do
    [ -d "$dir" ] || continue
    [ -d "$dir/.git" ] || [ -f "$dir/.git" ] || continue
    local branch=$(git -C "$dir" branch --show-current 2>/dev/null)
    [ -z "$branch" ] && continue
    local name=$(basename "$dir")
    local ts=$(git -C "$dir" log -1 --format=%ct 2>/dev/null || echo "0")
    local dirty=$(git -C "$dir" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    local ahead=$(git -C "$dir" rev-list --count @{u}..HEAD 2>/dev/null || echo "?")
    local behind=$(git -C "$dir" rev-list --count HEAD..@{u} 2>/dev/null || echo "?")
    local info=""
    [[ "$dirty" -gt 0 ]] && info+="${dirty}d "
    [[ "$ahead" != "0" && "$ahead" != "?" ]] && info+="${ahead}+ "
    [[ "$behind" != "0" && "$behind" != "?" ]] && info+="${behind}- "
    [[ -z "$info" ]] && info="clean"
    (( ${#name} > maxname )) && maxname=${#name}
    (( ${#branch} > maxbranch )) && maxbranch=${#branch}
    rows+=("${ts}|${name}|${branch}|${info}")
  done
  printf '%s\n' "${rows[@]}" | sort -t'|' -k1 -rn | while IFS='|' read -r _ n b i; do
    printf "  %-${maxname}s  %-${maxbranch}s  %s\n" "$n" "$b" "$i"
  done
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
