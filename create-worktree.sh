#!/usr/bin/env bash

# Script to create a new worktree for the monoclonal repository
# Creates worktrees in the pattern: sdiehl/<branch-name> with directory sdiehl-<branch-name>

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
CGXS_GIT_CONTRIBUTOR="${CGXS_GIT_CONTRIBUTOR:-sdiehl}"
BARE_REPO="/Users/${CGXS_GIT_CONTRIBUTOR}/Git/monoclonal-bare"
WORKTREES_DIR="/Users/${CGXS_GIT_CONTRIBUTOR}/Git/monoclonal-worktrees"
DEFAULT_BASE_BRANCH="main"

# Function to print colored messages
print_info() {
    printf "${BLUE}[INFO]${NC} %s\n" "$1"
}

print_success() {
    printf "${GREEN}[SUCCESS]${NC} %s\n" "$1"
}

print_error() {
    printf "${RED}[ERROR]${NC} %s\n" "$1"
}

print_warning() {
    printf "${YELLOW}[WARNING]${NC} %s\n" "$1"
}

# Check if we're in the right place
if [[ ! -d "$BARE_REPO" ]]; then
    print_error "Bare repository not found at $BARE_REPO"
    exit 1
fi

# Prompt for branch name
printf "${BLUE}=== Create New Worktree ===${NC}\n"
echo
echo "Enter the feature name (without '${CGXS_GIT_CONTRIBUTOR}/' prefix)"
echo "Examples: venue-abstraction, ipl-format, mic-types"
echo
read -p "Feature name: " feature_name

# Validate input
if [[ -z "$feature_name" ]]; then
    print_error "Feature name cannot be empty"
    exit 1
fi

# Sanitize input (remove any leading/trailing whitespace)
feature_name=$(echo "$feature_name" | xargs)

# Check if feature name already has contributor prefix and remove it
if [[ "$feature_name" == ${CGXS_GIT_CONTRIBUTOR}/* ]]; then
    feature_name="${feature_name#${CGXS_GIT_CONTRIBUTOR}/}"
    print_warning "Removed '${CGXS_GIT_CONTRIBUTOR}/' prefix from input"
fi

# Construct branch name and directory name
BRANCH_NAME="${CGXS_GIT_CONTRIBUTOR}/$feature_name"
WORKTREE_DIR_NAME="${CGXS_GIT_CONTRIBUTOR}-$feature_name"
WORKTREE_PATH="$WORKTREES_DIR/$WORKTREE_DIR_NAME"

# Check if worktree already exists
if [[ -d "$WORKTREE_PATH" ]]; then
    print_error "Worktree already exists at $WORKTREE_PATH"
    exit 1
fi

# Ask for base branch (default to main)
echo
read -p "Base branch [${DEFAULT_BASE_BRANCH}]: " base_branch
base_branch=${base_branch:-$DEFAULT_BASE_BRANCH}

# Confirm before creating
echo
echo "About to create:"
printf "  Branch name: ${GREEN}%s${NC}\n" "$BRANCH_NAME"
printf "  Worktree path: ${GREEN}%s${NC}\n" "$WORKTREE_PATH"
printf "  Based on: ${GREEN}%s${NC}\n" "$base_branch"
echo
read -p "Continue? [y/N]: " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    print_info "Operation cancelled"
    exit 0
fi

# Create the worktree
print_info "Creating worktree..."
cd "$BARE_REPO"

# Fetch latest if using a remote branch
if [[ "$base_branch" == origin/* ]] || [[ "$base_branch" == "main" ]]; then
    print_info "Fetching latest from origin..."
    git fetch origin main 2>/dev/null || true
fi

# Create the worktree
if git worktree add -b "$BRANCH_NAME" "$WORKTREE_PATH" "$base_branch"; then
    print_success "Worktree created successfully!"
    echo

    # Verify and show info
    if [[ -d "$WORKTREE_PATH" ]]; then
        print_info "Worktree details:"
        git worktree list | grep "$WORKTREE_DIR_NAME" || true
        echo
        print_info "To navigate to your new worktree:"
        echo "  cd $WORKTREE_PATH"
        echo

        # Ask if user wants to cd to the new worktree
        read -p "Change to new worktree directory now? [y/N]: " go_to_worktree
        if [[ "$go_to_worktree" =~ ^[Yy]$ ]]; then
            echo "Run: cd $WORKTREE_PATH"
            echo "(Note: Script cannot change parent shell directory)"
        fi
    fi
else
    print_error "Failed to create worktree"
    exit 1
fi
