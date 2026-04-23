# ==============================================
# OH-MY-ZSH
# ==============================================

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git extract git-extras rust zsh-autosuggestions zsh-syntax-highlighting)

# Speed: skip compaudit security check, disable paste magic, skip auto-title
ZSH_DISABLE_COMPFIX=true
DISABLE_MAGIC_FUNCTIONS=true
DISABLE_AUTO_TITLE=true

zstyle ':omz:update' mode disabled
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

source $ZSH/oh-my-zsh.sh

# ==============================================
# PATH
# ==============================================

export PATH=$HOME/bin:/usr/local/bin:$PATH
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
# MCP keys loaded from ~/.zshrc_local (not committed to git)

# GitHub token: lazy-load from keychain on first gh invocation
ghtoken() {
  export GITHUB_TOKEN="$(security find-generic-password -a $USER -s github-token -w 2>/dev/null)"
}
gh() {
  if [[ -z "$GITHUB_TOKEN" ]]; then
    ghtoken
  fi
  unfunction gh 2>/dev/null
  command gh "$@"
}

unsetopt beep

# ==============================================
# ALIASES
# ==============================================

alias vim='nvim'
alias ls='ls --color'
alias j='z'
alias ag='rg'
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

wtl() {
  local bare="$WORKTREE_BARE"
  local origin_main=$(git -C "$bare" rev-parse refs/remotes/origin/main 2>/dev/null)
  local rows=()
  local maxname=0 maxbranch=0

  while IFS= read -r line; do
    if [[ "$line" =~ ^worktree\ (.+) ]]; then
      local wt_path="${match[1]}"
      local head="" branch="" name=""
      name=$(basename "$wt_path")
    elif [[ "$line" == "bare" ]]; then
      continue
    elif [[ "$line" =~ ^HEAD\ (.+) ]]; then
      head="${match[1]}"
    elif [[ "$line" =~ ^branch\ refs/heads/(.+) ]]; then
      branch="${match[1]}"
    elif [[ -z "$line" && -n "$head" ]]; then
      local age=$(git -C "$bare" log -1 --format='%cr' "$head" 2>/dev/null)
      local behind=""
      if [[ -n "$origin_main" ]]; then
        local n=$(git -C "$bare" rev-list --count "$head".."$origin_main" 2>/dev/null)
        if [[ "$n" -gt 0 ]] 2>/dev/null; then
          behind="${n} behind main"
        else
          behind="up to date"
        fi
      fi
      (( ${#name} > maxname )) && maxname=${#name}
      (( ${#branch} > maxbranch )) && maxbranch=${#branch}
      rows+=("${name}|${branch}|${age}|${behind}")
      head="" branch=""
    fi
  done < <(git -C "$bare" worktree list --porcelain 2>/dev/null; echo "")

  for row in "${rows[@]}"; do
    IFS='|' read -r n b a bh <<< "$row"
    printf "  %-${maxname}s  %-${maxbranch}s  %-14s %s\n" "$n" "$b" "$a" "$bh"
  done
}

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

alias ticky='~/Git/pygui/pygui.py'

# ==============================================
# TOOLS (cached init: regenerates when binary changes)
# ==============================================

# Cache tool init output, keyed on binary mtime
_cached_init() {
  local tool=$1 cache="$HOME/.cache/zsh/${tool}.zsh"
  local bin=$(command -v "$tool" 2>/dev/null) || return
  mkdir -p "$HOME/.cache/zsh"
  if [[ ! -f "$cache" || "$bin" -nt "$cache" ]]; then
    "$tool" init zsh > "$cache" 2>/dev/null
  fi
  source "$cache"
}

_cached_init zoxide
_cached_init atuin
unfunction _cached_init

eval "$(starship init zsh)"

# fzf: use fd for file search, bat for preview
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'

# fzf shell integration (Ctrl+T file picker, Alt+C cd, ** completions)
[[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
[[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]] && source /opt/homebrew/opt/fzf/shell/completion.zsh

# nvm: put default node on PATH immediately (no sourcing cost),
# lazy-load full nvm only when you run `nvm` directly.
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/alias/default" ]]; then
  _nvm_ver=$(<"$NVM_DIR/alias/default")
  _nvm_dir="$NVM_DIR/versions/node/v${_nvm_ver}"
  # Alias may be major-only (e.g. "22"); fall back to latest matching patch.
  # Use a zsh glob (not `ls`) so aliases/colorization don't poison the path.
  if [[ ! -d "$_nvm_dir" ]]; then
    _nvm_matches=("$NVM_DIR/versions/node/v${_nvm_ver}."*(/N))
    (( ${#_nvm_matches} )) && _nvm_dir="${_nvm_matches[-1]}"
    unset _nvm_matches
  fi
  [[ -d "$_nvm_dir/bin" ]] && export PATH="$_nvm_dir/bin:$PATH"
  unset _nvm_ver _nvm_dir
fi
nvm() {
  unset -f nvm
  [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]] && source "/opt/homebrew/opt/nvm/nvm.sh"
  nvm "$@"
}

[[ -r "$HOME/.opam/opam-init/init.zsh" ]] && source "$HOME/.opam/opam-init/init.zsh" &>/dev/null

[[ -r "$HOME/.elan/env" ]] && source "$HOME/.elan/env"

[[ -d "$HOME/.lmstudio/bin" ]] && export PATH="$PATH:$HOME/.lmstudio/bin"

[[ -d "/opt/homebrew/opt/ccache/libexec" ]] && export PATH="$PATH:/opt/homebrew/opt/ccache/libexec"

# ==============================================
# LOCAL CONFIG (not in repo)
# ==============================================

[[ -r "$HOME/.zshrc_work" ]] && source "$HOME/.zshrc_work"
[[ -r "$HOME/.zshrc_local" ]] && source "$HOME/.zshrc_local"

# uv-managed Python (must be last to ensure precedence over system Python)
path=("$HOME/.local/bin" ${path:#$HOME/.local/bin})

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
