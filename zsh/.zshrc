ZSH_DISABLE_COMPFIX="true"
export ZSH=~/.oh-my-zsh
export PATH=~/.composer/vendor/bin:$PATH

# preferred theme
ZSH_THEME="gentoo"

plugins=(git ssh-agent zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# local overrides
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

export PATH="$PATH:/opt/nvim-linux64/bin"
export PATH="$HOME/.tmuxifier/bin:$PATH"
export TMUXIFIER_LAYOUT_PATH="$HOME/dotfiles/tmux/layouts"
ZSH_AUTOSUGGEST_STRATEGY=match_prev_cmd

[[ -d /usr/local/go ]] && export GOROOT="/usr/local/go"
[[ -d /usr/local/go ]] && export GOPATH="$HOME/go"
[[ -d /usr/local/go ]] && export PATH="$GOPATH/bin:$GOROOT/bin:$PATH"

autoload -U add-zsh-hook

auto_nvm_use() {
  if ! command -v nvm &> /dev/null; then
    return
  fi
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    info "Found .nvmrc file: Switching node version to $(cat .nvmrc)"
    nvm use > /dev/null
  fi
}

add-zsh-hook chpwd auto_nvm_use
nvm use default

export PATH="/opt/nvim-linux64/bin:$PATH"

set -o vi true

export QT_QPA_PLATFORM=xcb

eval "$(starship init zsh)"
