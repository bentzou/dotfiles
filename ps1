#!/bin/bash

# PS1
red_b='\033[1;31m'
green_b='\033[1;32m'
yellow_b='\033[1;33m'
lightblue='\033[94m'
lightgreen='\033[92m'
default='\033[0m'

ps1_branch () {
   # print PS1-ready, truncated, colorized branch
   local br
   local max_len=30

   # get git branch
   ! git branch &>/dev/null && return 1
   br="$(git branch | egrep "^\*" | cut -d' ' -f2-)"
   br="$(basename "$br")"
   (( ${#br} > $max_len )) && br="${br:0:$max_len-2}.."

   # get color depending on branch
   if [ "$br" = "main" ] || [ "$br" = "master" ]; then
      color="$red_b"
   else
      color="$green_b"
   fi

   # print colorized branch
   echo '\['${color}'\]'${br}'\['${default}'\]'
}

ps1_virtualenv () {
   # print python virtual environment
   local virtualenv

   # get env
   [ -z "${VIRTUAL_ENV:-}" ] && return 1
   virtualenv="$(basename $VIRTUAL_ENV)"

   # print colorized env
   echo '\['${green_b}'\]'"$virtualenv"'\['${default}'\]'
}

ps1_saymyname () {
   # print my name in color
   echo '\['${lightblue}'\]'"ben"'\['${default}'\]'
}

ps1_override () {
   [ -n "${PS1_OVERRIDE:-}" ] && echo '\['${yellow_b}'\]'${PS1_OVERRIDE:-}'\['${default}'\]'
}

ps1_prefix () {
   local override="$(ps1_override)"
   [ -n "$override" ] && echo $override && return

   # print branch if exists
   local prefixes=$(join , $(ps1_virtualenv) $(ps1_branch))
   [ -n "$prefixes" ] && echo $prefixes || ps1_saymyname
}

ps1 () {
   PS1="$(ps1_prefix)\[${lightblue}\] \w> \[\e[m\]"
}

PROMPT_COMMAND="${PROMPT_COMMAND:-:}; ps1"
