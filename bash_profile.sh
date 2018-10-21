# Import bash modules

# This is work related. Remove on personal laptop.
. ~/bash_profile_modules/apps_helper.sh

. ~/bash_profile_modules/color_helper.sh
. ~/bash_profile_modules/git_helper.sh
. ~/bash_profile_modules/git-prompt.sh
. ~/bash_profile_modules/customize_terminal_helper.sh


# General Alias
# alias bp='code ~/.bash_profile'
alias bp='code ~/bash_profile_modules ~/.bash_profile'
alias sbp='source ~/.bash_profile'
alias nginxConfig='code /usr/local/etc/nginx/nginx.conf'
alias hostFile='code /etc/hosts'
alias ggitignore='code ~/.gitignore_global'
alias npmrcFile='code ~/.npmrc'
alias gitcon="code ~/.gitconfig"

alias g='gulp'

alias ll='ls -alG'
alias ls='ls -G'
alias c='clear'

alias rnginx='sudo brew services restart nginx'
alias snginx='sudo brew services stop nginx'

alias repos='cd /Users/lcy3yzv/Documents/repos/'

alias findCursor='printf "$ESC[?25h"'

# For NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# MVN cli stuff (Not sure what this does anymore)
# export M2_HOME=/Users/mkyong/apache-maven-3.1.1
# export PATH=$PATH:$M2_HOME/bin

# General Functions
function chrome() {
  echo $@
  open -na "Google Chrome" --args --new-window $@
}

google() {
  if [[ $@ = *"--m"* ]]; then
    local searchString="http://www.google.com/search?q="
    local searchURLs=""
    echo "Googling... looking for $@ respectively"
    for term in $@; do
      [[ $term = "--m" ]] && searchURLs="$searchURLs" || searchURLs="$searchURLs $searchString$term"
    done;
    chrome $searchURLs
  else
    local search="";
    echo "Googling.... looking for $@";
    # This is for when there's white space inbetween words. But can only search for 1 word;
    for term in $@; do
      search="$search%20$term"
    done;
    # Could use xdg-open to open the URL in any default browser.
    chrome "http://www.google.com/search?q=$search";
  fi
}

openconf() {
  PS3='Select an option: '
  # this is for options formatting so it won't show in the same lines
  COLUMNS=12
  local options=("bash profile -- bp" "nginx config -- nc" "host file -- hf" "npmrc" "global gitignore -- ggi" "global git config -- ggc")
  select opt in "${options[@]}"; do
    case "$opt,$REPLY" in
      "bash profile -- bp",*|*,"bp"|*,"bash profile") bp; break ;;
      "nginx config -- nc",*|*,"nc"|*,"nginx config") nginxConfig; break ;;
      "host file -- hf",*|*,"host file"|*,"hf") hostFile; break ;;
      "npmrc",*|*,"npmrc") npmrcFile; break ;;
      "global gitignore -- ggi",*|*,"global gitignore"|*,"ggi") ggitignore; break ;;
      "global git config -- ggc",*|*,"global git config"|*,"ggc") gitcon; break ;;      
      *) echo "invalid option $REPLY"; break ;;
    esac
  done
}

function fg() {
  # -i ignore case distinctions
  env | grep -i "$1"
}

function findport() {
  sudo lsof -i ":$1"
}

function killport() {
  kill -9 $1
}

function fkport() {
  # -t produce just terse(simple) output
  # -i select the list of all internet address
  kill -9 $(sudo lsof -t -i ":$1")
}

function toUpperCase() {
    echo "$1" | tr '[:lower:]' '[:upper:]'
}

function toLowerCase() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

function verifyParamExists() {
  if [ ! -z "$1" ]; then
    true
  else
    false
  fi
}

function confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure?} [y/N]" response
    case "$response" in
        [yY][eE][sS]|[yY])
          echo $response
            true
            ;;
        *)
            false
            ;;
    esac
}

function select_option {

    # little helpers for terminal print control and key input
    ESC=$( printf "\033")
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "   $1  "; }
    print_selected()   { printf " > $ESC[4;35m $1 $ESC[0;0m"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()        { read -sn3 key 2>/dev/null >&2
                         if [[ $key = $ESC[A ]]; then echo up;    fi
                         if [[ $key = $ESC[B ]]; then echo down;  fi
                         if [[ $key = ""     ]]; then echo enter; fi; }

    # initially print empty new lines (scroll down if at bottom of screen)
    for opt; do printf "\n"; done

    # determine current screen position for overwriting the options
    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - $#))

    # ensure cursor and input echoing back on upon a ctrl+c during read -s
    trap "cursor_blink_on; stty echo; printf '\n'; exit;" 1
    cursor_blink_off

    local selected=0
    while true; do
        # print options by overwriting the last lines
        local idx=0
        for opt; do
            cursor_to $(($startrow + $idx))
            if [ $idx -eq $selected ]; then
                print_selected "$opt"
            else
                print_option "$opt"
            fi
            ((idx++))
        done

        # user key control
        case `key_input` in
            enter) break;;
            up)    ((selected--));
                   if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;
            down)  ((selected++));
                   if [ $selected -ge $# ]; then selected=0; fi;;           
        esac
    done

    # cursor position back to normal
    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $selected
}
