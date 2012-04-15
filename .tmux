set-option -g default-terminal "screen-256color"
set -g visual-activity on
setw -g aggressive-resize on

# More straight forward key bindings for splitting
unbind %
bind | split-window -h
bind h split-window -h
unbind '"'
bind - split-window -v
bind v split-window -v
