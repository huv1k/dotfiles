#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
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

# --- Remove old bare repo if it exists ---
if [ -d "$HOME/.config/dotfiles" ]; then
  warn "Removing old bare repo at ~/.config/dotfiles"
  rm -rf "$HOME/.config/dotfiles"
fi

# --- Stow dotfiles ---
info "Stowing dotfiles from $DOTFILES_DIR..."
stow -v -d "$(dirname "$DOTFILES_DIR")" -t "$HOME" "$(basename "$DOTFILES_DIR")" 2>&1 \
  || warn "Some conflicts detected. Try: stow --adopt -d $(dirname "$DOTFILES_DIR") -t ~ $(basename "$DOTFILES_DIR")"

info "Done! Dotfiles are symlinked from $DOTFILES_DIR into ~"
