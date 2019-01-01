# Path to Oh My Fish install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

# Load Oh My Fish configuration.
source $OMF_PATH/init.fish
  
  
# Utils
function take 
  mkdir -p $argv; cd $argv
end

# List
alias l="ls -a"

# Clear screan
alias c="clear"

# Folders
alias p="cd ~/Projects"
alias s="cd ~/Sites"
alias d="cd ~/Downloads"

# Git
alias ga='git add'
alias gaa='git add --all'
alias gcmsg='git commit -m'
alias gpom="git push origin master"

# IP
alias ip="ifconfig |grep inet"

# Prisma 
alias pr="prisma"