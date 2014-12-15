fpath=(/home/stephen/zsh-completions/src $fpath)

xset b off # get rid of f#&*ing beep
bindkey -v
export KEYTIMEOUT=1
export EDITOR=vim

alias google-chrome="google-chrome --ignore-gpu-blacklist"

export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'

export PATH="/usr/lib/colorgcc/bin:$PATH"
set -o vi

autoload -Uz compinit && compinit
zstyle :compinstall filename '$HOME/.zshrc'
# autoload -U compinit ; compinit -u
#
autoload -U colors && colors

setopt AUTO_CD                # cd if no matching command
setopt AUTO_PARAM_SLASH       # adds slash at end of tabbed dirs
setopt CHECK_JOBS             # check bg jobs on exit
setopt CORRECT                # corrects spelling
setopt CORRECT_ALL            # corrects spelling
setopt EXTENDED_GLOB          # globs #, ~ and ^
setopt EXTENDED_HISTORY       # saves timestamps on history
setopt GLOB_DOTS              # find dotfiles easier
setopt HASH_CMDS              # save cmd location to skip PATH lookup
setopt HIST_EXPIRE_DUPS_FIRST # expire duped history first
setopt HIST_NO_STORE          # don't save 'history' cmd in history
setopt INC_APPEND_HISTORY     # append history as command are entered
setopt LIST_ROWS_FIRST        # completion options left-to-right, top-to-bottom
setopt LIST_TYPES             # show file types in list
setopt MARK_DIRS              # adds slash to end of completed dirs
setopt NUMERIC_GLOB_SORT      # sort numerically first, before alpha
setopt PROMPT_SUBST           # sub values in prompt
setopt RM_STAR_WAIT           # pause before confirming rm *
setopt SHARE_HISTORY          # share history between open shells

# Networking
alias warp='wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant.conf'
alias pst="ps -Leo pid,tid,comm"
alias siteget="wget --recursive --no-clobber --page-requisites --html-extension --convert-links --restrict-file-names=windows"

# Haskell
alias ghci="ghci -v0"

alias ghci-sandbox="ghci -no-user-package-db -package-db .cabal-sandbox/*-packages.conf.d"
alias ghc-sandbox="ghc -no-user-package-db -package-db .cabal-sandbox/*-packages.conf.d"
alias runhaskell-sandbox="runhaskell -no-user-package-db -package-db .cabal-sandbox/*-packages.conf.d"

alias ghc-7.8="/home/stephen/Git/ghc/bin/ghc-7.8.1"
alias ghci-7.8="/home/stephen/Git/ghc/bin/ghci-7.8.1"
alias ghcii="ghci -v0 -ghci-script ~/.ghc/ghci_alt.conf"
alias cryptol="/home/stephen/Git/cryptol/.cabal-sandbox/bin/cryptol"
alias cabal-bounds="/home/stephen/Git/cabal-bounds-0.6/dist/build/cabal-bounds/cabal-bounds"
alias nix-haskell="nix-env -qaP \* | grep haskellPackages | less"
alias ghci-core="ghci -fforce-recomp -ddump-simpl -dsuppress-idinfo -dsuppress-coercions -dsuppress-type-applications -dsuppress-uniques -dsuppress-module-prefixes"
alias ghci-stg="ghc -fforce-recomp -ddump-stg -dsuppress-idinfo -dsuppress-coercions -dsuppress-uniques -dsuppress-module-prefixes"
alias ghc-cmm="ghc -fforce-recomp -ddump-stg -ddump-cmm -dsuppress-idinfo -dsuppress-coercions -dsuppress-uniques -dsuppress-module-prefixes"

lhs2hs() { 
  sed '
    s/^>//
    t
    s/^ *$//
    t
    s/^/-- /
   ' $1 > $2
}

# C Programming
function massif() {
  valgrind --tool=massif --massif-out-file=massif.prof $1 && ms_print massif.prof | less
}
alias ass="astyle --style=1tbs --lineend=linux --convert-tabs --preserve-date --fill-empty-lines --pad-header --indent-switches --align-pointer=name --align-reference=name --pad-oper"

# J programming language
alias j="jfe --console"

# General System Aliases

alias vol="alsamixer --card 0"
alias ls="ls --color -h"
alias screen="screen -q"
alias myip="/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'"

# Git stuff
alias gst='git status'
alias gl='git pull origin $(parse_git_branch)'
alias glr='git pull --rebase origin $(parse_git_branch)'
#alias gp='git push origin $(parse_git_branch)'
alias gd='git diff --no-ext-diff -w "$@" | vim -R -'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gb='git branch'
alias gba='git branch -a'
alias grn="git log --format=oneline  --abbrev-commit --no-merges"
alias gfa="git fetch --all"
alias gci="git commit --interactive"
alias gco='git checkout'
compdef gco=git

###
# get the name of the branch we are on
###
parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}

# Tab completion
# --------------

zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

## Completion for processes
[ "$USER" = "root" ] && SWITCH='-A' || SWITCH="-u ${USER}"
zstyle ':completion:*:processes-names' command \
    "ps c $SWITCH -o command | uniq"
zstyle ':completion:*:processes' command \
    "ps c $SWITCH -o pid -o command | uniq"
unset SWITCH

# Extract Archives
ex () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1    ;;
            *.tar.gz)    tar xzf $1    ;;
            *.bz2)       bunzip2 $1    ;;
            *.rar)       rar x $1      ;;
            *.gz)        gunzip $1     ;;
            *.tar)       tar xf $1     ;;
            *.tbz2)      tar xjf $1    ;;
            *.tgz)       tar xzf $1    ;;
            *.zip)       unzip $1      ;;
            *.Z)         uncompress $1 ;;
            *.7z)        7z x $1       ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# NixOS path
alias nix='source /home/stephen/.nix-profile/etc/profile.d/nix.sh'

# Work ZSH config is a extension of this file
alias work='source /home/stephen/.zshrc_python'

# Python Environment
# ------------------

# Use Anaconda by Default
VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2
export PATH=/home/stephen/continuum/anaconda/bin:$PATH
alias python3=/home/stephen/continuum/anaconda/envs/py33/bin/python3.3

# Haskell Environment
# -------------------

# Add GHC & Haskell Platform to PATH if present
if [ -d "$HOME/.haskell/bin" ]; then
    export PATH=$PATH:$HOME/.haskell/bin
fi

# ... and any installed Cabal packages
if [ -d "$HOME/.cabal/bin" ]; then
    export PATH=$PATH:$HOME/.cabal/bin
fi

# ... and any installed Cabal packages
if [ -d "$HOME/AgdaStdLib/src" ]; then
    export PATH=$PATH:$HOME/AgdaStdLib/src
fi

# ... and CUDA
if [ -d "/opt/cuda/bin" ]; then
    export PATH=$PATH:/opt/cuda/bin
fi


function zle-line-init zle-keymap-select {
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# if mode indicator wasn't setup by theme, define default
if [[ "$MODE_INDICATOR" == "" ]]; then
  MODE_INDICATOR="%{$fg_bold[red]%}<%{$fg[red]%}<<%{$reset_color%}"
fi

function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/}"
}

function git_diff() {
  git diff --no-ext-diff -w "$@" | vim -R -
}

waits () {
    CMD=$@
    echo $CMD
    while :
    do
        echo "reading"
        read -s -n 1 key
        echo $key

        if [[ $key = "" ]]
        then
            reset
            date
            eval $CMD
        fi
    done
}

function cabal_sandbox_info() {
    cabal_files=(*.cabal(N))
    if [ $#cabal_files -gt 0 ]; then
        if [ -f cabal.sandbox.config ]; then
            echo "%{$fg[green]%}sandboxed%{$reset_color%}"
        else
            echo "%{$fg[red]%}not sandboxed%{$reset_color%}"
        fi
    fi
}
 
#RPROMPT="\$(cabal_sandbox_info) $RPROMPT"

function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]% %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $(cabal_sandbox_info) $EPS1"
    zle reset-prompt
}
