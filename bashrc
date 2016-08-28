#!/bin/bash

set -o nounset


# IMPORTS
   SOURCE_DIR="$(b=${BASH_SOURCE[0]}; dirname $(readlink $b || echo $b))"
   source "$SOURCE_DIR"/completions
   source "$SOURCE_DIR"/functions
   source "$SOURCE_DIR"/ps1
   source "$SOURCE_DIR"/setuphome
   source "$SOURCE_DIR"/modules/uptown/uptown
   source "$SOURCE_DIR"/modules/flash/flash
   source "$SOURCE_DIR"/modules/backtothefolder/bttf


# PATHS
   export PATH=$PATH:$HOME/bin


# MISC SHELL OPTIONS
   # allow forward searching in history using C-s (vs C-r for backward)
   stty -ixon

   # enable color in the terminal bash shell
   export CLICOLOR=1

   # bash history: ignore duplicate commands, erase previous duplicates
   export HISTCONTROL=ignoredups:erasedups

   # set up the color scheme for ls
   export LSCOLORS=gxfxcxdxbxegedabagacad

   # enable color for iTerm
   export TERM=screen-256color


# ALIASES
   alias ..='cd ..'
   alias ...='cd ../..'
   alias ....='cd ../../..'
   alias cp='cp -i'
   alias mkdir='mkdir -pv'
   alias mv='mv -i'
   alias rm='rm -i'
   alias tf='tail -100f'
   alias tm='tmux'
   alias vi='vim'

   # ide
   alias ecl='open -a eclipse'

   # maven
   export MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
   alias mvn="mvn -Dbuildtime.output.log=true -T 4 --offline -Dmaven.compile.fork=true -Dmaven.junit.fork=true -Dmaven.junit.jvmargs=-Xmx512m"
   alias mcc="mvn clean compile"
   alias mci="mvn clean install"
   alias mi="mvn install -DskipTests"
   alias mt="mvn surefire:test failsafe:integration-test"

   # git
   alias gb="git branch"
   alias gc="git checkout"
   alias gd="git diff"
   alias gl="git log -20 --graph --decorate --pretty=oneline --abbrev-commit"
   alias gs="git status"

   # bashrc
   alias sbp="source $SOURCE_DIR/bashrc"
   alias vbp="vi $SOURCE_DIR/bashrc"

   # ssh
   alias vsc="vi $HOME/.ssh/config"


# LAST FILE
   # saves the last word from the last line of a list
   LASTWORD=/tmp/lastword

   glw () { [ -f "$LASTWORD" ] && cat "$LASTWORD" 2>/dev/null; }
   slw () { tee >(rmcolor | egrep -v "(\.|\.\.)$" | tail -1 | rev | cut -d' ' -f1 | rev > "$LASTWORD"); }


# FUNCTIONS
   # fast find and grep
   f () { flash_find "$@" | slw; }
   g () { flash_grep "$@"; }

   # search for java class file
   fc () { (( $# == 1 )) && f "${1//.//}"; }

   # print full path for argument and copy to clipboard
   p () { local tmp="$(path "$@")"; echo "$tmp"; tmp=(${tmp[@]}); echo -n "${tmp[@]}" | pbcopy &>/dev/null; }

   # grep processes
   pg () { (( $# == 1 )) && echo "ps -ef | grep -i $1" && ps -ef | grep -i $1; }

   # quickly view csv/tsv files with column formatting in less
   viewcsv () { sed 's/,/ ,/g' | column -s, -t "$@" | less -c -#20 -N -S; }
   viewtsv () { column -s'\t' -t "$@" | less -c -#20 -N -S; }
   viewpsv () { sed 's/|/ |/g' | column -s'|' -t "$@" | less -c -#20 -N -S; }

   # navigation shortcuts
   lr () { CLICOLOR_FORCE=1 ls -alhtr "$@" | slw; }
   ll () { CLICOLOR_FORCE=1 ls -alh "$@" | slw; }

   cd () { builtin cd "$@" 2>/dev/null; (( $? != 0 )) && builtin cd "$(dirname $@)"; ll; }

   cl () { [ -d "$(glw)" ] && cd "$(glw)"; }
   vl () { local w; w="$(glw)"; [ -f "$w" ] && { press_any_to_continue "vi $w"; echo; [ "$i" != "q" ] && vi "$w"; }; }
