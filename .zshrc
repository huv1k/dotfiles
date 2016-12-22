# Path to your oh-my-zsh installation.
export ZSH=/Users/Huvik/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="clean"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(atom cake brew git sublime osx npm node theme )

# User configuration

export PATH="/Library/TeX/texbin:/Library/Frameworks/Python.framework/Versions/3.4/bin:/usr/local/mysql/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/texbin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

#Clear screan
alias c="clear"
#Folders
alias p="~/Projects"
alias s="~/Sites"
alias d="~/Downloads"
#Wordpress install
alias wpi="curl -O https://wordpress.org/latest.tar.gz; tar -xvzf latest.tar.gz; mv wordpress/* .;rmdir wordpress/ ; rm latest.tar.gz;cp wp-config-sample.php wp-config.php;"
#Git
alias gpom="git push origin master"
#IP
alias ip="ifconfig |grep inet"
#Weather
alias brno="curl wttr.in/brno"
alias weather='function _weather(){ curl "wttr.in/$1"; };_weather'
EDITOR="atom"
#SQL
alias ss="mysql.server start"
#NPM run
alias r="npm run"
