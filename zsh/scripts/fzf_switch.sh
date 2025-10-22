#!/usr/bin/bash

main() {
  # local branches="$(git branch -l)";
  # echo "$branches"
  # if [[ -z "$branches" ]]; then
  #   ~/dotfiles/zsh/scripts/messages.sh "error" "No scripts found in current directory";
  #   return 1;
  # fi
  local branch="$(git branch -l | fzf --preview 'batcat -p {}')";
  "$(git switch $branch)"
}

main
