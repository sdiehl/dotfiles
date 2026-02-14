#!/usr/bin/env bash
# Shared functions for morning/eod scripts

VAULT="$HOME/Documents/DevBrain"
WORKTREE_ROOT="${WORKTREE_ROOT:-$HOME/work}"
GIT_SCAN_DIRS=("$WORKTREE_ROOT" "$HOME/Git")

# List all git repos across scan dirs
find_repos() {
    for dir in "${GIT_SCAN_DIRS[@]}"; do
        [ -d "$dir" ] || continue
        find "$dir" -maxdepth 4 -name ".git" -type d 2>/dev/null | while read -r g; do
            dirname "$g"
        done
    done
}

# Inject content after a ## heading in a markdown file
inject_section() {
    local heading="$1"
    local content="$2"
    local file="$3"
    [ -z "$content" ] && return
    local tmpfile
    tmpfile=$(mktemp)
    local in_section=0
    local injected=0
    while IFS= read -r line; do
        if [ "$line" = "## $heading" ]; then
            {
                echo "$line"
                echo ""
                echo "$content"
            } >>"$tmpfile"
            in_section=1
            injected=1
            continue
        fi
        if [ "$in_section" -eq 1 ]; then
            if [[ "$line" == "## "* ]]; then
                in_section=0
                echo "$line" >>"$tmpfile"
            fi
            continue
        fi
        echo "$line" >>"$tmpfile"
    done <"$file"
    if [ "$injected" -eq 1 ]; then
        mv "$tmpfile" "$file"
    else
        rm -f "$tmpfile"
    fi
}
