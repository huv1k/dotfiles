# Path

set -gx PATH /opt/homebrew/bin $PATH

zoxide init fish | source
fnm env --use-on-cd | source
source ~/.config/fish/secrets.fish

# Brewfile location
export HOMEBREW_BREWFILE=$HOME/.Brewfile

# Utils
function take
  mkdir -p $argv; cd $argv
end

alias dot='/usr/bin/git --git-dir=$HOME/.config/dotfiles/ --work-tree=$HOME'

# List
alias l='ls -a'

# Clear screan
alias c='clear'

# Folders
alias d='cd ~/Developer'
alias dl='cd ~/Downloads'

# Git
alias gf='git checkout -f master && git pull'
alias gd='git diff'
alias gn='git checkout -b'
alias gs='git status'
alias gb='git branch'
alias gc='git checkout'
alias gr='git reset --soft HEAD~1'
alias gp='git pull'
alias gl='git log --graph --all --oneline --decorate'
alias ga='git add'
alias gaa='git add --all'
alias gcmsg='git commit -m'
alias gpom='git push origin master'
alias stash='git stash'
alias f="git commit --fixup"
alias g="git"
alias p="pnpm"
alias ls="eza"
alias lg="lazygit"

# IP
alias ip='ifconfig |grep inet'

# Unset enviroment variable
function unset
  set --erase $argv
end

# Docker
alias ds='docker stop (docker ps -q)'
function remove-containers
  docker stop (docker ps -aq)
  docker rm (docker ps -aq)
end

function docker-cleanup
  remove-containers
  docker network prune -f
  docker rmi -f (docker images --filter dangling=true -qa)
  docker volume rm (docker volume ls --filter dangling=true -q)
  docker rmi -f (docker images -qa)
end

# Fun stuff
alias brno='curl wttr.in/brno'
function weather
  curl 'wttr.in/'$argv
end

function fb
  git rev-parse HEAD > /dev/null 2>&1 || return

  git branch --color=always --all --sort=-committerdate |
  cut -c 3- |
  fzf --height 50% --ansi --no-multi --preview-window right:65% --preview 'git log -n 50 --color=always --date=short --pretty="format:%C(auto)%cd %h%d %s" {}' |
  xargs git checkout
end
# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

[ -f ~/.inshellisense/key-bindings.fish ] && source ~/.inshellisense/key-bindings.fish
# pnpm
set -gx PNPM_HOME "/Users/lukas.huvar/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
