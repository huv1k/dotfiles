#!/bin/bash

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
fisher install jukben/z

## Brew utils
brew install tig
brew install fzf
brew install node
brew install tree
brew install n
brew install z
brew install gh
brew install yarn

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

## Setup settings
# git clone https://github.com/huv1k/dotfiles ~/Developer/00dotfiles
rm -rf ~/Library/Application\ Support/Code/User
ln -s ~/Developer/00dotfiles/vscode ~/Library/Application\ Support/Code/User
ln -s ~/Developer/00dotfiles/.config/config.fish ~/.config/fish/config.fish

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