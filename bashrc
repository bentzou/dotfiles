#!/bin/bash



# IMPORTS
   SOURCE_DIR="$(b=${BASH_SOURCE[0]}; dirname $(readlink $b || echo $b))"
   source "$SOURCE_DIR"/functions
   source "$SOURCE_DIR"/completions
   source "$SOURCE_DIR"/ps1
   source "$SOURCE_DIR"/setuphome
   source "$SOURCE_DIR"/postcd
   source "$SOURCE_DIR"/modules/uptown/uptown
   source "$SOURCE_DIR"/modules/flash/flash
   source "$SOURCE_DIR"/modules/backtothefolder/bttf


# PATHS
   export PATH=$PATH:$HOME/bin:$HOME/Library/Python/2.7/bin

# JAVA
   export GRADLE_OPTS="-Dorg.gradle.daemon=true -Dorg.gradle.configureondemand=true -Dorg.gradle.configuration-cache=true -Dorg.gradle.caching=true"


# MISC SHELL OPTIONS
   # allow forward searching in history using C-s (vs C-r for backward)
   stty -ixon

   # enable color in the terminal bash shell
   export CLICOLOR=1

   # bash history: ignore duplicate commands, erase previous duplicates
   export HISTCONTROL=ignoredups:erasedups
   export HISTIGNORE='ll:ll *:ls'
   export PROMPT_COMMAND="history -a; ${PROMPT_COMMAND:-}"

   # set up the color scheme for ls
   export LSCOLORS=gxfxcxdxbxegedabagacad

   # enable color for iTerm
   export TERM=screen-256color


# ALIASES
   alias ..='cd ..'
   alias ...='cd ../..'
   alias ....='cd ../../..'
   alias cp='cp -i'
   alias ds='find . -type d'
   alias mkdir='mkdir -pv'
   alias mv='mv -i'
   alias rm='rm -i'
   alias tf='tail -100f'
   alias tm='tmux'
   alias vi='vim'

   function _code_dirs() {
      local cur="${COMP_WORDS[COMP_CWORD]}"
      local repos="$(find "$HOME/Code" -type d -maxdepth 1 -mindepth 1 -not -path '*/\.*' | xargs basename)"
      COMPREPLY=($(compgen -W "$repos" -- ${cur}))
   }
   
   complete -F _code_dirs c

   function c () { cd ~/Code/${1:-}; }

   # ide
   alias ecl='open -a eclipse'

   # maven
   export MAVEN_OPTS="-XX:+TieredCompilation -XX:TieredStopAtLevel=1"
   alias mcc="mvn clean compile"
   alias mci="mvn clean install"
   #alias mci="mvn clean install -Dlog4j.configuration=file:/Users/bentzou/Code/log4j.xml"
   alias mi="mvn install -DskipTests"
   alias mt="mvn surefire:test failsafe:integration-test"

   # git
   alias ga="git add"
   alias gb="git branch --sort=-committerdate"
   alias gc="git checkout"
   alias gd="git diff"
   alias gdc="git diff --cached"
   alias gl="git log -20 --graph --decorate --pretty=oneline --abbrev-commit"
   alias gs="git status"
   alias gsl="git stash list"

   # vagrant
   alias vd="vagrant destroy"
   alias vu="vagrant up"
   alias vp="vagrant provision"

   # bashrc
   alias sbp="source $SOURCE_DIR/bashrc"
   alias vbp="vi $SOURCE_DIR/bashrc"

   # ssh
   alias vsc="vi $HOME/.ssh/config"


# GIT
git_repo_name () {
   local repo_dir=$(git rev-parse --show-toplevel 2>/dev/null)
   [ -n "$repo_dir" ] && basename "$repo_dir"
}

set_term_to_repo () {
   local repo_name=$(git_repo_name)
   set_terminal_title "${repo_name:-}"
}

set_prompt_command set_term_to_repo

activate () {
   local path="$(find . -name activate)"
   if [ -f "$path" ]; then
      echo -n $path
      press_any_to_continue && source $path;
   fi

   local env_path=".env"
   if [ -f "$env_path" ]; then
      echo -n $env_path
      press_any_to_continue && set -a && source $env_path && set +a
   fi

   if ! psql -l &>/dev/null; then
      echo -n "brew services run postgresql@16"
      # press_any_to_continue && LC_ALL="C" /opt/homebrew/opt/postgresql@16/bin/postgres -D /opt/homebrew/var/postgresql@16
      press_any_to_continue && brew services run postgresql@16 
   fi

   if ! redis-cli ping &>/dev/null; then
      echo -n "brew services run redis"
      press_any_to_continue && brew services run redis
   fi
}


# LAST FILE
   # saves the last word from the last line of a list
   LASTWORD=/tmp/lastword

   glw () { [ -f "$LASTWORD" ] && cat "$LASTWORD" 2>/dev/null; }
   slw () { tee >(rmcolor | egrep -v "(\.|\.\.)$" | tail -1 | rev | cut -d' ' -f1 | rev > "$LASTWORD"); }


# FUNCTIONS
   # fast find and grep
   f () { flash_find_file "$@" | slw; }
   d () { flash_find_directory "$@" | slw; }
   g () { flash_grep "$@"; }
   fv () { f "$@"; vl; }

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
   function lr () { CLICOLOR_FORCE=1 ls -alhtr "$@" | slw; }
   function ll () { CLICOLOR_FORCE=1 ls -alh "$@" | slw; }

   cd () {
      builtin cd "$@" 2>/dev/null;
      (( $? != 0 )) && builtin cd "$(dirname $@)";
      ll;
      _post_cd;
   }

   cl () { cd "$(glw)"; }
   vl () { local w; w="$(glw)"; [ -f "$w" ] && press_any_to_continue "vi $w" && { echo; vi "$w"; history -s "vi $w"; }; }
