#!/usr/bin/env bash

# Comprehensive worktree management script for monoclonal repository
# Provides create, list, and remove functionality

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
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

# Function to list worktrees
list_worktrees() {
    printf "${CYAN}=== Existing Worktrees ===${NC}\n"
    echo
    cd "$BARE_REPO"
    git worktree list | while IFS= read -r line; do
        if [[ "$line" == *"(bare)"* ]]; then
            printf "${BLUE}%s${NC}\n" "$line"
        elif [[ "$line" == *"${CGXS_GIT_CONTRIBUTOR}/"* ]]; then
            printf "${GREEN}%s${NC}\n" "$line"
        else
            echo "$line"
        fi
    done
    echo
}

# Function to create a new worktree
create_worktree() {
    printf "${BLUE}=== Create New Worktree ===${NC}\n"
    echo
    echo "Enter the feature name (without '${CGXS_GIT_CONTRIBUTOR}/' prefix)"
    echo "Examples: venue-abstraction, ipl-format, mic-types"
    echo
    read -p "Feature name: " feature_name

    # Validate input
    if [[ -z "$feature_name" ]]; then
        print_error "Feature name cannot be empty"
        return 1
    fi

    # Sanitize input
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
        return 1
    fi

    # Ask for base branch
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
        return 0
    fi

    # Create the worktree
    print_info "Creating worktree..."
    cd "$BARE_REPO"

    # Fetch latest if using main
    if [[ "$base_branch" == "main" ]]; then
        print_info "Fetching latest from origin..."
        git fetch origin main 2>/dev/null || true
    fi

    # Create the worktree
    if git worktree add -b "$BRANCH_NAME" "$WORKTREE_PATH" "$base_branch"; then
        print_success "Worktree created successfully!"
        echo
        print_info "To navigate to your new worktree:"
        echo "  cd $WORKTREE_PATH"
    else
        print_error "Failed to create worktree"
        return 1
    fi
}

# Function to remove a worktree
remove_worktree() {
    printf "${YELLOW}=== Remove Worktree ===${NC}\n"
    echo

    # List worktrees with numbers
    cd "$BARE_REPO"
    echo "Select worktree to remove:"
    echo

    # Get worktrees (excluding bare repo)
    worktrees=()
    while IFS= read -r line; do
        if [[ "$line" != *"(bare)"* ]]; then
            worktrees+=("$line")
        fi
    done < <(git worktree list)

    if [[ ${#worktrees[@]} -eq 0 ]]; then
        print_warning "No worktrees to remove"
        return 0
    fi

    # Display numbered list
    for i in "${!worktrees[@]}"; do
        echo "$((i+1)). ${worktrees[$i]}"
    done
    echo
    read -p "Enter number (or 'q' to quit): " selection

    if [[ "$selection" == "q" ]]; then
        print_info "Operation cancelled"
        return 0
    fi

    if ! [[ "$selection" =~ ^[0-9]+$ ]] || [[ $selection -lt 1 ]] || [[ $selection -gt ${#worktrees[@]} ]]; then
        print_error "Invalid selection"
        return 1
    fi

    # Extract path from selected worktree
    selected_line="${worktrees[$((selection-1))]}"
    worktree_path=$(echo "$selected_line" | awk '{print $1}')

    echo
    printf "About to remove: ${RED}%s${NC}\n" "$worktree_path"
    read -p "Are you sure? [y/N]: " confirm

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        if git worktree remove "$worktree_path" --force; then
            print_success "Worktree removed successfully"
        else
            print_error "Failed to remove worktree"
            return 1
        fi
    else
        print_info "Operation cancelled"
    fi
}

# Main menu
show_menu() {
    printf "${CYAN}===================================${NC}\n"
    printf "${CYAN}   Monoclonal Worktree Manager${NC}\n"
    printf "${CYAN}===================================${NC}\n"
    echo
    echo "1. List existing worktrees"
    echo "2. Create new worktree"
    echo "3. Remove worktree"
    echo "4. Exit"
    echo
    read -p "Select option [1-4]: " choice

    case $choice in
        1)
            list_worktrees
            ;;
        2)
            create_worktree
            ;;
        3)
            remove_worktree
            ;;
        4)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            print_error "Invalid option"
            ;;
    esac
}

# Check prerequisites
if [[ ! -d "$BARE_REPO" ]]; then
    print_error "Bare repository not found at $BARE_REPO"
    exit 1
fi

# Main loop
while true; do
    show_menu
    echo
    read -p "Press Enter to continue..."
    clear
done