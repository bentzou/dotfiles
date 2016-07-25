#!/bin/bash

# PS1
red_b='\033[1;31m'
green_b='\033[1;32m'
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
   [ "$br" = "master" ] && color="$red_b" || color="$green_b"

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

ps1_prefix () {
   # print branch if exists
   local prefixes=$(join , $(ps1_virtualenv) $(ps1_branch))
   [ -n "$prefixes" ] && echo $prefixes || ps1_saymyname
}

prompt_cmd () {
   PS1="$(ps1_prefix)\[${lightblue}\] \w> \[\e[m\]"
   uptown_set_path
}

PROMPT_COMMAND=prompt_cmd
