# Path

set -gx PATH ~/Projects/10productboard/pb-toolkit/docker/bin $PATH

# Utils
function take 
  mkdir -p $argv; cd $argv
end

# List
alias l='ls -a'

# Clear screan
alias c='clear'

# Folders
alias p='cd ~/Projects'
alias d='cd ~/Downloads'

# Git
alias gh='git push origin HEAD'
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

# IP
alias ip='ifconfig |grep inet'

# Prisma 
alias pr='prisma2'

# Shortcuts
alias s='yarn start'
alias e='yarn electron-start'

alias cu='rm -rf node_modules && git checkout -f master'

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
  curl 'wttr.in/$argv'
end
