# Keyboard Shortcuts

CapsLock = Escape.

## Ghostty

| Shortcut                  | Action                  |
| ------------------------- | ----------------------- |
| Cmd+Backtick              | Quick terminal (global) |
| Cmd+N                     | New window              |
| Cmd+T                     | New tab                 |
| Cmd+W                     | Close tab/split         |
| Cmd+Shift+W               | Close window            |
| Cmd+D                     | Split right             |
| Cmd+Shift+D               | Split down              |
| Cmd+[ / Cmd+]             | Prev/next split         |
| Cmd+Opt+Arrows            | Navigate splits         |
| Cmd+Ctrl+Arrows           | Resize split            |
| Cmd+Ctrl+=                | Equalize splits         |
| Cmd+Shift+Enter           | Zoom split              |
| Cmd+Enter                 | Fullscreen              |
| Cmd+= / Cmd+-             | Font size up/down       |
| Cmd+0                     | Reset font size         |
| Cmd+K                     | Clear screen            |
| Cmd+Up / Cmd+Down         | Prev/next prompt        |
| Cmd+Shift+,               | Reload config           |
| Cmd+,                     | Open config             |
| Cmd+Shift+P               | Command palette         |
| Ctrl+Tab / Ctrl+Shift+Tab | Next/prev tab           |

## Neovim

Leader is Space. Local-leader is backslash.

| Shortcut       | Action                                 |
| -------------- | -------------------------------------- |
| Ctrl+J         | Next window split                      |
| Backtick       | Last edit position                     |
| gl             | Alternate file                         |
| F12            | Equalize splits                        |
| Space+/        | Case-insensitive search                |
| Enter          | Clear search highlight                 |
| Ctrl+T         | New tab                                |
| tn / tp        | Next/prev tab                          |
| q (then a-z)   | Record macro (q to stop)               |
| q: / q/ / q?   | Disabled (avoid cmdline-window pop-up) |
| Esc (terminal) | Exit terminal mode                     |

### Neo-tree

| Shortcut | Action           |
| -------- | ---------------- |
| Ctrl+N   | Toggle file tree |
| Enter    | Open/expand      |
| a        | Add file         |
| d        | Delete           |
| r        | Rename           |
| c / m    | Copy / move      |
| R        | Refresh          |
| ?        | Help             |

### Telescope

| Shortcut        | Action           |
| --------------- | ---------------- |
| Ctrl+P          | Find files       |
| Ctrl+G          | Live grep        |
| Enter           | Open             |
| Ctrl+X          | Open in hsplit   |
| Ctrl+V          | Open in vsplit   |
| Ctrl+T          | Open in tab      |
| Ctrl+N / Ctrl+P | Next/prev result |
| Esc             | Close            |

### Fugitive (git)

| Shortcut    | Action  |
| ----------- | ------- |
| Space+gd    | Diff    |
| gb          | Blame   |
| do (visual) | Diffget |

### Easy-align (visual mode)

| Shortcut | Align on    |
| -------- | ----------- |
| a=       | `=`         |
| a;       | `::`        |
| a,       | `,`         |
| a-       | `->`        |
| ga       | Interactive |

### LSP

| Shortcut | Action               |
| -------- | -------------------- |
| gd       | Go to definition     |
| gD       | Go to declaration    |
| K        | Hover docs           |
| gi       | Implementation       |
| gr       | References           |
| Space+rn | Rename               |
| Space+ca | Code action          |
| [d / ]d  | Prev/next diagnostic |

Inlay hints are auto-enabled on attach (rust-analyzer and any other server that supports them).

### Completion (blink.cmp)

| Shortcut        | Action               |
| --------------- | -------------------- |
| Ctrl+Space      | Show completion menu |
| Ctrl+y          | Accept selection     |
| Ctrl+n / Ctrl+p | Next / prev item     |
| Ctrl+e          | Hide menu            |

### Copilot (copilot.lua)

| Shortcut | Action                   |
| -------- | ------------------------ |
| Tab      | Accept inline suggestion |
| Alt+]    | Next suggestion          |
| Alt+[    | Previous suggestion      |
| Ctrl+]   | Dismiss suggestion       |

### Trouble (diagnostics panel)

| Shortcut           | Action                        |
| ------------------ | ----------------------------- |
| Space+xx           | Toggle workspace diagnostics  |
| Space+xX           | Toggle buffer diagnostics     |
| Space+cs           | Toggle document symbols panel |
| Space+cl           | Toggle LSP defs/refs panel    |
| Space+xq           | Toggle quickfix list          |
| Ctrl+Q (Telescope) | Send results to Trouble       |
| q (in Trouble)     | Close Trouble                 |
| o (in Trouble)     | Jump to item and close        |
| Enter (in Trouble) | Jump to item                  |
| } / {              | Next / prev item              |
| Ctrl+S             | Open in horizontal split      |
| Ctrl+V             | Open in vertical split        |
| s                  | Cycle severity filter         |
| gb (in Trouble)    | Toggle current-buffer-only    |

### Comment.nvim

| Shortcut    | Action                   |
| ----------- | ------------------------ |
| gcc         | Toggle line comment      |
| gc (visual) | Toggle selection comment |
| gbc         | Toggle block comment     |

## Shell

| Shortcut | Action                  |
| -------- | ----------------------- |
| Ctrl+R   | Atuin fuzzy history     |
| Up       | Atuin directory history |

### Aliases

| Alias       | Expands to                                         |
| ----------- | -------------------------------------------------- |
| `vim`       | `nvim`                                             |
| `ls`        | `ls --color`                                       |
| `j`         | `z` (zoxide)                                       |
| `ag`        | `rg` (ripgrep)                                     |
| `pcr`       | `pre-commit run --all-files`                       |
| `pcp`       | `pre-commit run --hook-stage pre-push --all-files` |
| `gpp`       | `git push origin --no-verify`                      |
| `claudes`   | `claude --dangerously-skip-permissions`            |
| `codexs`    | `codex --full-auto`                                |
| `geminis`   | `gemini --yolo`                                    |
| `opencodes` | `opencode --yolo`                                  |

## macOS

| Setting        | Value                              |
| -------------- | ---------------------------------- |
| CapsLock       | Escape                             |
| Key repeat     | 2 / 15 (fast)                      |
| Press-and-hold | Disabled                           |
| Natural scroll | Disabled                           |
| Dock           | Autohide, 48px                     |
| Finder         | Hidden files, path bar, status bar |
| Screenshots    | ~/Downloads                        |
| Autocorrect    | Disabled                           |
