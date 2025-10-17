#!/usr/bin/env bash

# Source this file to add worktree management aliases
# Add to your ~/.zshrc or ~/.bashrc:
#   export CGXS_GIT_CONTRIBUTOR=your-username  # Optional, defaults to 'sdiehl'
#   source /path/to/worktree-aliases.sh

# Set default contributor if not already set
CGXS_GIT_CONTRIBUTOR="${CGXS_GIT_CONTRIBUTOR:-sdiehl}"

# Quick worktree creation
alias wt-create="/Users/${CGXS_GIT_CONTRIBUTOR}/Git/monoclonal-worktrees/create-worktree.sh"

# Full worktree management menu
alias wt-manage="/Users/${CGXS_GIT_CONTRIBUTOR}/Git/monoclonal-worktrees/manage-worktrees.sh"

# Quick worktree listing
alias wt-list="cd /Users/${CGXS_GIT_CONTRIBUTOR}/Git/monoclonal-bare && git worktree list"

# Navigate to worktrees directory
alias wt-cd="cd /Users/${CGXS_GIT_CONTRIBUTOR}/Git/monoclonal-worktrees"

# Quick navigation to specific worktrees (add your commonly used ones)
alias wt-main="cd /Users/${CGXS_GIT_CONTRIBUTOR}/Git/monoclonal-worktrees/main"
alias wt-bare="cd /Users/${CGXS_GIT_CONTRIBUTOR}/Git/monoclonal-bare"
