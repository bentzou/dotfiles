#!/bin/bash

# PS1
red_b='\033[1;31m'
green_b='\033[1;32m'
lightblue='\033[94m'
default='\033[0m'

ps1_branch () {
   # print PS1-ready, truncated, colorized branch
   local br
   local max_len=30

   # get git branch
   ! git branch &>/dev/null && return 1
   br="$(git branch | egrep "^\*" | cut -d' ' -f2)"
   br="$(basename $br)"
   (( ${#br} > $max_len )) && br="${br:0:$max_len-2}.."

   # get color depending on branch
   [ "$br" = "master" ] && color="$red_b" || color="$green_b"

   # print colorized branch
   echo '\['${color}'\]'${br}'\['${default}'\]'
}

ps1_saymyname () {
   # print my name in color
   echo '\['${lightblue}'\]'"ben"'\['${default}'\]'
}

ps1_prefix () {
   # print branch if exists
   local br=$(ps1_branch)
   [ -n "$br" ] && ps1_branch || ps1_saymyname
}

prompt_cmd () {
   PS1="$(ps1_prefix)\[${lightblue}\] \w> \[\e[m\]"
}

PROMPT_COMMAND=prompt_cmd
