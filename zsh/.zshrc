ZSH_DISABLE_COMPFIX="true"
export ZSH=~/.oh-my-zsh
export PATH=~/.composer/vendor/bin:$PATH

# preferred theme
ZSH_THEME="gentoo"

plugins=(git ssh-agent)

source $ZSH/oh-my-zsh.sh

export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/usr/local/share/zsh-syntax-highlighting/highlighters

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

# local overrides
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

export PATH="$PATH:/usr/cli-tool/"
export PATH="$PATH:/opt/nvim-linux64/bin"
export TMUXIFIER_LAYOUT_PATH="$HOME/dotfiles/tmux-layouts"

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

bindkey "^[k" up-line-or-history
bindkey "^[j" down-line-or-history

