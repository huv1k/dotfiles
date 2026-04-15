#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/Developer/dotfiles"
DOTFILES_REPO="https://github.com/huv1k/dotfiles.git"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# --- Install stow if missing ---
if ! command -v stow &>/dev/null; then
  info "Installing GNU Stow..."
  if command -v brew &>/dev/null; then
    brew install stow
  else
    error "stow is not installed and brew is not available. Install stow manually."
  fi
fi

# --- Clone or update repo ---
if [ -d "$DOTFILES_DIR/.git" ]; then
  info "Dotfiles repo already exists at $DOTFILES_DIR"
else
  info "Cloning dotfiles into $DOTFILES_DIR..."
  git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

# --- Restructure repo for stow (one-time migration) ---
migrate() {
  info "Restructuring repo for GNU Stow..."
  cd "$DOTFILES_DIR"

  mkdir -p git tmux zsh fish/.config ghostty/.config nix-darwin/.config zed/.config zellij/.config

  # Move top-level dotfiles into packages
  [ -f .gitconfig ] && mv .gitconfig git/.gitconfig
  [ -f .gitignore ] && mv .gitignore git/.gitignore
  [ -f .tmux.conf ] && mv .tmux.conf tmux/.tmux.conf
  [ -f .zshrc ]     && mv .zshrc zsh/.zshrc

  # Move .config subdirectories into their own packages
  for pkg in fish ghostty nix-darwin zed zellij; do
    if [ -d ".config/$pkg" ]; then
      mv ".config/$pkg" "$pkg/.config/$pkg"
    fi
  done

  # Remove .config if empty
  rmdir .config 2>/dev/null || true

  info "Migration complete. Review changes with 'git status' in $DOTFILES_DIR"
}

# Check if migration is needed (top-level .gitconfig still exists = old layout)
if [ -f "$DOTFILES_DIR/.gitconfig" ]; then
  warn "Detected old bare-repo layout. Migrating to stow structure..."
  migrate
fi

# --- Remove old bare repo if it exists ---
if [ -d "$HOME/.config/dotfiles" ]; then
  warn "Removing old bare repo at ~/.config/dotfiles"
  rm -rf "$HOME/.config/dotfiles"
fi

# --- Stow packages ---
cd "$DOTFILES_DIR"

PACKAGES=(git tmux zsh fish ghostty nix-darwin zed zellij)

for pkg in "${PACKAGES[@]}"; do
  if [ -d "$pkg" ]; then
    info "Stowing $pkg..."
    stow -v -t "$HOME" "$pkg" 2>&1 || warn "Failed to stow $pkg (conflicts?). Run: stow --adopt -t ~ $pkg"
  fi
done

info "Done! Dotfiles are symlinked from $DOTFILES_DIR into ~"
info "To add a new dotfile:  mv ~/.newfile $DOTFILES_DIR/<package>/.newfile && stow -t ~ <package>"
info "To remove symlinks:    stow -D -t ~ <package>"
