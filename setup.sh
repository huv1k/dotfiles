#!/usr/bin/env bash

screenshots_location=~/Documents/Screenshots/

setup_screenshots () {
  if [ ! -d $screenshots_location ]; then
    mkdir $screenshots_location
  fi

  defaults write com.apple.screencapture location $screenshots_location
  killall SystemUIServer
}

setup_screenshots