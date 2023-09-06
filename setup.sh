#!/bin/bash

# setup_screenshots
screenshots_location=~/Documents/Screenshots/

## Setup developer folder
mkdir ~/Developer

## Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
## Add brew to PATH
export PATH=/opt/homebrew/bin:$PATH

## Fish
brew install fish
sudo echo /usr/local/bin/fish >> /etc/shells
chsh -s /usr/local/bin/fish
## Fisher
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
fisher install jethrokuan/fzf

## Brew utils
brew install tig
brew install fzf
brew install node
brew install tree
brew install n
brew install z
brew install gh
brew install yarn
brew install jq
brew install bat
brew install exa
brew install tldr
brew install fd
brew install zoxide

## Software
brew install --cask visual-studio-code
brew install --cask caprine
brew install --cask notion
brew install --cask discord
brew install --cask iterm2
brew install --cask vlc
brew install --cask brave-browser
brew install --cask figma
brew install --cask spotify
brew install --cask steam
brew install --cask raindropio
brew install --cask cleanshot
brew install --cask cron
brew install --cask telegram
brew install --cask betterdisplay

## Setup settings
git clone https://github.com/huv1k/dotfiles ~/Developer/00dotfiles
rm -rf ~/Library/Application\ Support/Code/User
ln -s ~/Developer/00dotfiles/vscode ~/Library/Application\ Support/Code/User
ln -s ~/Developer/00dotfiles/fish/config.fish ~/.config/fish/config.fish
ln -s ~/Developer/00dotfiles/fish/secrets.fish ~/.config/fish/secret.fish
ln -s ~/Developer/00dotfiles/.tmux.conf ~/.tmux.conf

## Show path in finder
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true; killall Finder

## Configure git
git config --global push.default current

## Screenshots
setup_screenshots () {
  if [ ! -d $screenshots_location ]; then
    mkdir $screenshots_location
  fi

  defaults write com.apple.screencapture location $screenshots_location
  killall SystemUIServer
}



# Setup aliases
brew alias
for f in $HOME/00dotfiles/.brew-aliases/* ; do
  ln -s $f "$(brew --prefix)/bin/brew-$(basename $f)"
done