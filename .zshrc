# Path to your oh-my-zsh installation.
export ZSH=/Users/Huvik/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="cloudy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(atom cake brew git zsh-autosuggestions osx npm node theme ssh-agent)

# User configuration

# export PATH="/usr/local/mysql/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:~/.composer/vendor/bin:/usr/local/go/bin:~/.local/bin:~/Library/Python/2.7/bin:~/Library/Python/3.6/bin"
# export MANPATH="/usr/local/man:$MANPATH"
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/huvik/Library/Python/3.6/bin:/usr/local/go/bin:/Users/huvik/go/bin"
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
EDITOR="code"
#SQL
alias ss="mysql.server start"
#NPM run
alias r="npm run"
#Graphcool
alias gc="graphcool"
alias pr="prisma"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# google cloud
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh