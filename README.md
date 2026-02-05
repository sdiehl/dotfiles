# Dotfiles

[![CI](https://github.com/sdiehl/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/sdiehl/dotfiles/actions/workflows/ci.yml)

```bash
make all       # Full setup
make brew      # Install packages
make configs   # Symlink configs
make macos     # Set macOS defaults
make devenv    # Node, Rust, Lean4
make obsidian  # Setup vault structure
make claude    # Configure Claude Code MCP
make codex     # Configure Codex
make opencode  # Configure OpenCode
make clean     # Remove symlinks
```

```bash
./sync.sh      # Pull configs from local machine
```

## AI Agent Configuration

Three AI coding agents are configured with shared rules and access to an Obsidian knowledge graph.

| Agent       | Config Location                    | Instructions                            |
| ----------- | ---------------------------------- | --------------------------------------- |
| Claude Code | `~/.claude/CLAUDE.md`              | Global rules + path-specific rules      |
| Codex       | `~/.codex/AGENTS.md`               | Global rules + agent-overlay delegation |
| OpenCode    | `~/.config/opencode/opencode.json` | MCP config only                         |

### Shared Rules

All agents follow:

- **Git read-only**: No commits, pushes, merges, or PR creation
- **Worktree conventions**: `~/work/worktrees/sdiehl-<branch>`
- **Knowledge base**: Query DevBrain via Obsidian MCP

### Codex + Agent-Overlay

When working in `~/work/` worktrees, Codex delegates to the corporate `agent-overlay` framework when present.

## Obsidian Knowledge Graph

AI agents connect to an Obsidian vault via MCP for semantic search and graph traversal.

**Setup:**

```bash
make obsidian                    # Create vault structure
```

Then in Obsidian GUI:

1. Open `~/Documents/DevBrain` as vault
2. Enable Community Plugins
3. Install BRAT plugin
4. BRAT -> Add Beta Plugin -> `aaronsb/obsidian-mcp-plugin`
5. Enable "Semantic MCP" plugin
6. Copy API key from Semantic MCP settings

**Configure agents:**

```bash
export OBSIDIAN_MCP_KEY="your-api-key"  # Add to .zshrc
make claude      # Configure Claude Code
make codex       # Configure Codex
make opencode    # Configure OpenCode
```

**Config locations:**

- Claude Code: `~/.claude/CLAUDE.md`, `~/.claude.json`
- Codex: `~/.codex/AGENTS.md`, `~/.codex/config.toml`
- OpenCode: `~/.config/opencode/opencode.json`
