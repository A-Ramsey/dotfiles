#!/usr/bin/bash

main() {
  local files="$(find *.sh -maxdepth 1 2>/dev/null)";
  if [[ -z "$files" ]]; then
    ~/dotfiles/zsh/scripts/messages.sh "error" "No scripts found in current directory";
    return 1;
  fi
  local cmd="$(find *.sh -maxdepth 1 | fzf --preview 'batcat -p {}')";
  if [[ -z "$cmd" ]]; then
    return 1;
  fi
  ~/dotfiles/zsh/scripts/messages.sh "info" "Running $cmd";
  "./$cmd"
  ~/dotfiles/zsh/scripts/messages.sh "success" "Running $cmd";
}

main
