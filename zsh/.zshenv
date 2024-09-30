# use vim by default for editing
export VISUAL=vim
export EDITOR=$VISUAL

# ensure our dotfiles bin directory is loaded first
export PATH="$HOME/.bin:/usr/local/sbin:$PATH"

# local overrides
[[ -f ~/.zshenv.local ]] && source ~/.zshenv.local

