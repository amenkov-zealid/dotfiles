#!/usr/bin/env bash
set -euo pipefail

# Fast but still controllable key repeat
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2

# Finder: show file extensions + path bar
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Dock: speed up app switching and reduce clutter
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false

killall Finder || true
killall Dock || true
