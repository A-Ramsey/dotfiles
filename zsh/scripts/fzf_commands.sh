#!/usr/bin/bash

main() {
  local files="$(find *.sh -maxdepth 1 2>/dev/null)";
  if [[ -z "$files" ]]; then
    ~/dotfiles/zsh/scripts/messages.sh "error" "No scripts found in current directory";
    return 1;
  fi
  local cmd="$(find *.sh -maxdepth 1 | fzf -q "$1" --preview 'batcat -p {}')";
  # Add a check to see if it is running localtests and if it is fzf over all the tests
  # and add that as a --filter to the command
  if [[ -z "$cmd" ]]; then
    return 1;
  fi
  ~/dotfiles/zsh/scripts/messages.sh "info" "Running $cmd";
  "./$cmd"
  history -s "./$cmd"
  ~/dotfiles/zsh/scripts/messages.sh "success" "Running $cmd";
}

main $1
