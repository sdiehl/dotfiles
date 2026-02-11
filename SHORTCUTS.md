# Keyboard Shortcuts

CapsLock = Escape. AeroSpace `alt` = Option key. AeroSpace `cmd` = Command key.

## AeroSpace

| Shortcut              | Action                         |
| --------------------- | ------------------------------ |
| Cmd+1..9              | Switch workspace               |
| Cmd+Shift+1..9        | Move window to workspace       |
| Cmd+Shift+Enter       | New Ghostty window             |
| Opt+H/J/K/L           | Focus left/down/up/right       |
| Opt+Shift+H/J/K/L     | Move window left/down/up/right |
| Opt+F                 | Fullscreen                     |
| Opt+Space             | Cycle tile layout              |
| Opt+Shift+Space       | Cycle accordion layout         |
| Opt+Minus / Opt+Equal | Shrink / grow window           |
| Opt+Shift+C           | Close window                   |
| Opt+W / E / R         | Focus monitor 1/2/3            |
| Opt+Shift+W / E / R   | Move window to monitor 1/2/3   |
| Opt+Tab               | Last workspace                 |
| Opt+Shift+Tab         | Move workspace to next monitor |
| Opt+Shift+;           | Enter service mode             |

### Service Mode

| Key               | Action                |
| ----------------- | --------------------- |
| Esc               | Reload config, exit   |
| R                 | Reset layout          |
| F                 | Toggle float/tile     |
| Backspace         | Close all but current |
| Opt+Shift+H/J/K/L | Join with neighbor    |

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

| Shortcut       | Action                  |
| -------------- | ----------------------- |
| Ctrl+J         | Next window split       |
| Backtick       | Last edit position      |
| gl             | Alternate file          |
| F12            | Equalize splits         |
| ff             | Case-insensitive search |
| Enter          | Clear search highlight  |
| Ctrl+T         | New tab                 |
| tn / tp        | Next/prev tab           |
| q              | Disabled (no macros)    |
| Esc (terminal) | Exit terminal mode      |

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
| gd          | Diff    |
| gb          | Blame   |
| do (visual) | Diffget |

### Tabular (visual mode)

| Shortcut | Align on |
| -------- | -------- |
| a=       | `=`      |
| a;       | `::`     |
| a,       | `,`      |
| a-       | `->`     |

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
