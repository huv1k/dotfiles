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

## Brew utils
brew install tig
brew install fzf
brew install node
brew install tree
brew install z
brew install gh
brew install yarn

## Software
brew cask install visual-studio-code
brew cask install caprine
brew cask install notion
brew cask install discord
brew cask install iterm2
brew cask install vlc
brew cask install brave-browser
brew cask install figma
brew cask install spotify
brew cask install steam

## Setup settings
git clone https://github.com/huv1k/dotfiles ~/Projects/00dotfiles
rm -rf ~/Library/ApplicationSupport/Code/User
ln -s ~/Projects/00dotfiles/vscode ~/Library/ApplicationSupport/Code/User

## Show path in finder
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true; killall Finder

## Screenshots
setup_screenshots () {
  if [ ! -d $screenshots_location ]; then
    mkdir $screenshots_location
  fi

  defaults write com.apple.screencapture location $screenshots_location
  killall SystemUIServer
}

setup_screenshots