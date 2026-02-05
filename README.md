# Dotfiles

[![CI](https://github.com/sdiehl/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/sdiehl/dotfiles/actions/workflows/ci.yml)

```bash
make all       # Full setup
make brew      # Install packages
make configs   # Symlink configs
make macos     # Set macOS defaults
make devenv    # Node, Rust, Lean4
make obsidian  # Setup vault structure
make clean     # Remove symlinks
```

```bash
./sync.sh      # Pull configs from local machine
```

## Obsidian Knowledge Graph

AI agents (Claude Code, OpenCode) connect to an Obsidian vault via MCP for semantic search and graph traversal.

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
export OBSIDIAN_MCP_KEY="your-api-key"
make claude      # Configure Claude Code
make opencode    # Configure OpenCode
```

Configs stored in:
- Claude Code: `~/.claude.json`
- OpenCode: `~/.config/opencode/opencode.json`
