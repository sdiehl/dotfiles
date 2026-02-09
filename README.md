# Dotfiles

[![CI](https://github.com/sdiehl/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/sdiehl/dotfiles/actions/workflows/ci.yml)

```bash
make all           # Full setup
make brew          # Install packages
make brew-dump     # Snapshot current brew packages to Brewfile
make configs       # Symlink configs (includes claude-config)
make claude-config # Symlink Claude Code config from DevBrain
make scripts       # Install ~/bin scripts (morning, eod)
make macos         # Set macOS defaults
make devenv        # Node, Rust, Lean4
make obsidian      # Setup vault structure
make claude        # Configure Claude Code MCP
make codex         # Configure Codex
make clean         # Remove symlinks
```

```bash
./sync.sh          # Pull configs from local machine
```

## Claude Code

Claude Code config (CLAUDE.md, rules, hooks, skills, commands, settings) lives in
`~/Documents/DevBrain/claude/` under git. `~/.claude/` contains symlinks into DevBrain.
`make claude-config` creates the symlinks. Skips gracefully if DevBrain is not present (CI).

| File                                   | Source of truth                        |
| -------------------------------------- | -------------------------------------- |
| `settings.json`                        | `DevBrain/claude/settings.json`        |
| `CLAUDE.md`                            | `DevBrain/claude/CLAUDE.md`            |
| `rules/onechronos.md`                  | `DevBrain/claude/rules/onechronos.md`  |
| `hooks/session-end.sh`                 | `DevBrain/claude/hooks/session-end.sh` |
| `skills/{morning,eod,standup,weekly}/` | `DevBrain/claude/skills/*/`            |
| `commands/{sync,morning,eod}.md`       | `DevBrain/claude/commands/`            |

## Other Agents

| Agent    | Config Location                    | Instructions                            |
| -------- | ---------------------------------- | --------------------------------------- |
| Codex    | `~/.codex/AGENTS.md`               | Global rules + agent-overlay delegation |
| OpenCode | `~/.config/opencode/opencode.json` | MCP config only                         |

## Obsidian Knowledge Graph

AI agents connect to an Obsidian vault via MCP for semantic search and graph traversal.

```bash
make obsidian    # Create vault structure
make claude      # Configure Claude Code MCP (requires OBSIDIAN_MCP_KEY)
```
