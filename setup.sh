#!/bin/bash

screenshots_location=~/Documents/Screenshots/

## Setup projects folder
mkdir ~/Projects

## Install brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

## Fish
brew install fish
sudo echo /usr/local/bin/fish >> /etc/shells
chsh -s /usr/local/bin/fish
#curl -L https://get.oh-my.fish | fish
#omf theme shellder

## Software
brew cask install visual-studio-code
brew cask install caprine
brew cask install notion


## Setup settings
git clone https://github.com/huv1k/dotfiles ~/Projects/00dotfiles
rm -rf ~/Library/ApplicationSupport/Code/User
ln -s ~/Projects/00dotfiles/vscode ~/Library/ApplicationSupport/Code/User

## Screenshots
setup_screenshots () {
  if [ ! -d $screenshots_location ]; then
    mkdir $screenshots_location
  fi

  defaults write com.apple.screencapture location $screenshots_location
  killall SystemUIServer
}

setup_screenshots