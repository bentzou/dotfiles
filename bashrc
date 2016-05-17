#!/bin/bash

set -o nounset

SOURCE_DIR="$(builtin cd "$(dirname "${BASH_SOURCE[0]}")" && builtin pwd)"
source "$SOURCE_DIR"/functions
source "$SOURCE_DIR"/setuphome
source "$SOURCE_DIR"/ps1


# PATHS
   export PATH=$PATH:$HOME/bin


# MISC SHELL OPTIONS
   # auto-expands any commands starting with ! after hitting space
   bind Space:magic-space
   
   # allow forward searching in history using C-s (vs C-r for backward)
   stty -ixon

   # enable color in the terminal bash shell
   export CLICOLOR=1
   
   # bash history: ignore duplicate commands, erase previous duplicates
   export HISTCONTROL=ignoredups:erasedups
   
   # set up the color scheme for ls
   export LSCOLORS=gxfxcxdxbxegedabagacad
   
   # enable color for iTerm
   export TERM=xterm-color


# ALIASES
   alias ..='cd ..'
   alias ...='cd ../..'
   alias ....='cd ../../..'
   alias grep='grep --color=auto'
   alias rm='rm -i'
   alias mkdir='mkdir -pv'
   alias tf='tail -100f'
   
   alias ecl='open -a eclipse'
   alias mci="mvn clean install"
   
   alias gb="git branch"
   alias gd="git diff"
   alias gs="git status"
   
   alias sbp="source $HOME/.bashrc_personal"
   alias vbp="vi $HOME/.bashrc_personal"


# FUNCTIONS
   f () { (( $# == 1 )) && find . -iname "*$(basename $1)*" | grep "$1"; }
   g () { case $# in 1) grep -rl "$1" .;; 2) grep -rl "$1" "$2";; esac; }
   gl () { case $# in 1) grep -r "$1" .;; 2) grep -r "$1" "$2";; esac; }
   p () { path "$@"; }
   pg () { (( $# == 1 )) && echo "ps -ef | grep -i $1" && ps -ef | grep -i $1; }
   viewcsv () { column -s, -t "$@" | less -c -#20 -N -S; }
   viewtsv () { column -s'\t' -t "$@" | less -c -#20 -N -S; }
   

# LAST FILE
   # saves the last file of an 'ls' listing
   LASTFILE=/tmp/lastfile
   
   glw () { [ -f "$LASTFILE" ] && cat "$LASTFILE" 2>/dev/null; }
   slw () { tee >(tail -1 | rmcolor | rev | cut -d' ' -f1 | rev > "$LASTFILE"); }
   
   lr () { CLICOLOR_FORCE=1 ls -alhtr "$@" | slw; }
   ll () { CLICOLOR_FORCE=1 ls -alh "$@" | slw; }

   cd () { builtin cd "$@" && ll; }
   
   cl () { [ -d "$(glw)" ] && cd "$(glw)"; }
   vl () { local w; w="$(glw)"; [ -f "$w" ] && { echo vi $w; sleep 1 && vi "$w"; }; }
