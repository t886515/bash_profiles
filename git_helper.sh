function gs () {
  git status $@
}

function gb() {
  git branch $@
}

function gc () {
  if verifyParamExists $1; then
    git checkout $@
  else
    local branches=$(git branch 2>/dev/null | cut -c 3- )

    if [[ $branches != "" ]]; then

      echo "Select a branch(Use ctrl+c to escape):"
      echo

      local options=($branches)
      local current=($(git rev-parse --abbrev-ref HEAD))
      options=(${options[@]/$current});

      select_option "${options[@]}"
      choice=$?

      git checkout ${options[$choice]}
    else
      echo "Can not find active branch. Are you sure this is a git repo?"
    fi

  fi
}

function cgit () {

  function gitPullOverwrite() {
    if verifyParamExists $1; then
      local REMOTE=$1
      local BRANCH=$(git rev-parse --abbrev-ref HEAD)
      if confirm "This OVERWRITES LOCAL COMMITS not in ${REMOTE}/${BRANCH}. Is this ok?"; then
        git fetch $REMOTE
        git reset $REMOTE/$BRANCH --hard
      fi
    else
      echo "specify remote to use"
    fi
  }

  case "$1" in
    pull)
      case "$2" in
        --overwrite|--o)
          gitPullOverwrite $3
          ;;
        *)
          git "$@"
          ;;
      esac
      ;;
    *)
      git "$@"
      ;;
  esac

}
