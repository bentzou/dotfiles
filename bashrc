#!/bin/bash

# Ghostty shell integration for Bash. This should be at the top of your bashrc!
if [ -n "${GHOSTTY_RESOURCES_DIR}" ]; then
    builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
fi


# IMPORTS
   SOURCE_DIR="$(b=${BASH_SOURCE[0]}; dirname $(readlink $b || echo $b))"
   source "$SOURCE_DIR"/functions
   source "$SOURCE_DIR"/completions
   source "$SOURCE_DIR"/ps1
   source "$SOURCE_DIR"/setuphome
   source "$SOURCE_DIR"/postcd
   source "$SOURCE_DIR"/modules/flash/flash
   # uptown and bttf call `bind` on init, which warns in non-interactive shells
   if [[ $- == *i* ]]; then
      source "$SOURCE_DIR"/modules/uptown/uptown
      source "$SOURCE_DIR"/modules/backtothefolder/bttf
   fi


# PATHS
   export PATH=$PATH:$HOME/bin:$HOME/Library/Python/2.7/bin

# JAVA
   export GRADLE_OPTS="-Dorg.gradle.daemon=true -Dorg.gradle.configureondemand=true -Dorg.gradle.configuration-cache=true -Dorg.gradle.caching=true"


# MISC SHELL OPTIONS
   # allow forward searching in history using C-s (vs C-r for backward)
   [[ $- == *i* ]] && stty -ixon

   # enable color in the terminal bash shell
   export CLICOLOR=1

   # bash history: ignore duplicate commands, erase previous duplicates
   export HISTCONTROL=ignoredups:erasedups
   export HISTIGNORE='ll:ll *:ls'
   export PROMPT_COMMAND="history -a; ${PROMPT_COMMAND:-}"

   # set up the color scheme for ls
   export LSCOLORS=gxfxcxdxbxegedabagacad



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

   # git
   alias ga="git add"
   alias gb="git branch --sort=-committerdate"
   alias gc="git checkout"
   alias gd="git diff"
   alias gdc="git diff --cached"
   alias gl="git log -20 --graph --decorate --pretty=oneline --abbrev-commit"
   alias gs="git status"
   alias gsl="git stash list"

   # just
   alias js='builtin cd ~/Code/ploy && just sync'
   jg () { local p; p=$(builtin cd ~/Code/ploy && just next) || return; builtin cd "$p"; }

   # Run the ploy justfile from anywhere, without changing the shell's cwd.
   j () { just --justfile ~/Code/ploy/justfile -d ~/Code/ploy "$@"; }

   # Report cwd to the terminal (OSC 7). Terminals like Ghostty/iTerm/WezTerm use
   # this so new tabs/splits open in the same directory. It normally fires at every
   # prompt, but jc cd's and launches claude without ever returning to a prompt —
   # so we emit it by hand.
   set_term_cwd () { printf '\e]7;file://%s%s\e\\' "${HOSTNAME:-localhost}" "$PWD"; }

   # Claim a ready clone (owned by this shell's $$, so closing the terminal frees
   # it), cd into its app dir so you stay there after claude exits, then release.
   # The app dir comes from CLONE_SUBDIR in ploy's spork config (clone root if
   # unset), so the monorepo knob lives in one place.
   # Args go to the CLI: bare words are joined into one prompt (`jc hello world`
   # == `jc "hello world"`); if any arg starts with `-`, all pass through as-is.
   spork_subdir () { ( . ~/Code/ploy/.spork.local/config 2>/dev/null; printf '%s' "${CLONE_SUBDIR:-}" ); }

   jc () {
      local clone sub
      case " $* " in *" -"*) ;; *) [ $# -gt 1 ] && set -- "$*";; esac
      clone=$(j claim $$) || return
      sub=$(spork_subdir)
      builtin cd "$clone${sub:+/$sub}" && set_term_cwd
      claude "$@"
      j release "$clone" $$
   }

   jx () {
      local clone sub
      case " $* " in *" -"*) ;; *) [ $# -gt 1 ] && set -- "$*";; esac
      clone=$(j claim $$ codex) || return
      sub=$(spork_subdir)
      builtin cd "$clone${sub:+/$sub}" && set_term_cwd
      codex "$@"
      j release "$clone" $$
   }

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
   local activate_path="$(find . -name activate)"
   if [ -f "$activate_path" ]; then
      cmd="source $activate_path"
      press_any_to_continue "$cmd " && $cmd
   elif [ -f "pyproject.toml" ]; then
      cmd="source $(poetry env info --path)/bin/activate"
      press_any_to_continue "$cmd " && $cmd
   fi

   local env_path=".env"
   if [ -f "$env_path" ]; then
      cmd="source $env_path"
      press_any_to_continue "$cmd " && set -a && $cmd && set +a
   fi

   if ! psql -l &>/dev/null; then
      cmd="brew services run postgresql@16"
      press_any_to_continue "$cmd " && $cmd
   fi

   if ! redis-cli ping &>/dev/null; then
      cmd="brew services run redis"
      press_any_to_continue "$cmd " && $cmd
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

#   cd () {
#      builtin cd "$@" 2>/dev/null;
#      (( $? != 0 )) && builtin cd "$(dirname $@)";
#      ll;
#      _post_cd;
#   }

   cl () { cd "$(glw)"; }
   vl () { local w; w="$(glw)"; [ -f "$w" ] && press_any_to_continue "vi $w" && { echo; vi "$w"; history -s "vi $w"; }; }
