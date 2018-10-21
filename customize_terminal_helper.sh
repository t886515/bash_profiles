# Bash
# red=$(tput setaf 1)
# green=$(tput setaf 2)
# yellow=$(tput setaf 3)
# blue=$(tput setaf 4)
# pink=$(tput setaf 5)
# white=$(tput setaf 7)
# gray=$(tput setaf 8)

# reset=$(tput sgr0)

# this shows user
# \u
# this is @
# @
# this is computer name(hostname)
# \h
# this is current directory
# \w
# this select the color for the next "item"
# \[$COLOR_NAME\]

GIT_PS1_SHOWDIRTYSTATE="on"
# PS1="$Green[\D{%Y %b %d (%a)}] $WHITE\T $LIGHT_PURPLE\u$WHITE@$BLUE\h$WHITE:$BYellow\w$GREEN$(__git_ps1 " (%s)")$Color_Off $ "
PROMPT_COMMAND='__git_ps1 "$Green[\D{%Y %b %d (%a)}] $WHITE\T $LIGHT_PURPLE\u$WHITE@$BLUE\h$WHITE:$BYellow\w$GREEN" "$Color_Off $ "'


# This set words after what you type back to white
# trap 'printf \\e[0m'
