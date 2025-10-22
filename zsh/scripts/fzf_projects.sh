#!/usr/bin/bash

window=false

while getopts ':w' flag; do
  case "${flag}" in
    "w") window=true;;
  esac
done

main() {
  local dir="$(find ~/projects/ -maxdepth 1 -type d -not -path '.' -not -path '/home/$USER/projects' |fzf --preview 'ls -lah {}')"
  if [[ -z "$dir" ]]; then
    return 1;
  fi
  windowName="$(basename "$dir")"
  windowName=$(echo "$windowName" | sed 's/\b./\u&/g' | tr '-' ' ')
  if $window; then
    export TMUXIFIER_PROJECT_DIR="$dir"
    export TMUXIFIER_SESSION_NAME=${windowName^}
    ~/dotfiles/zsh/scripts/messages.sh "info" "Opening new tmux window in $dir";
    ~/.tmux/plugins/tmuxifier/bin/tmuxifier load-window basic-project
    ~/dotfiles/zsh/scripts/messages.sh "success" "Opened new tmux window in $dir";
    return 0;
  fi
  ~/dotfiles/zsh/scripts/messages.sh "info" "Changing directory to $dir";
  tmux rename-window "$windowName"
  cd "$dir"
}


main
