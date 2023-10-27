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

## Setup settings
git clone https://github.com/huv1k/dotfiles ~/Developer/00dotfiles
rm -rf ~/Library/Application\ Support/Code/User
ln -s ~/Developer/00dotfiles/vscode ~/Library/Application\ Support/Code/User
ln -s ~/Developer/00dotfiles/fish/config.fish ~/.config/fish/config.fish
ln -s ~/Developer/00dotfiles/fish/secrets.fish ~/.config/fish/secret.fish
ln -s ~/Developer/00dotfiles/.tmux.conf ~/.tmux.conf

## Show path in finder 
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true; killall Finder
## Automatically hide dock
defaults write com.apple.dock autohide -bool true; killall Dock

## Configure git
git config --global push.default current

# Setup brew aliases
brew alias
for f in ~/.brew-aliases/* ; do
  ln -s $f "$(brew --prefix)/bin/brew-$(basename $f)"
done

# Setup bundle
HOMEBREW_BREWFILE=~/.Brewfile
brew bundle
brew sync

## Screenshots
setup_screenshots () {
  if [ ! -d $screenshots_location ]; then
    mkdir $screenshots_location
  fi

  defaults write com.apple.screencapture location $screenshots_location
  killall SystemUIServer
}