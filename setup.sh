#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/huv1k/dotfiles.git"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/Developer/dotfiles}"
DARWIN_CONFIG="huvik"
BOOTSTRAP_NIX_CONFIG=$'experimental-features = nix-command flakes\naccept-flake-config = true'

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info() { printf "${GREEN}[INFO]${NC} %s\n" "$1"; }
warn() { printf "${YELLOW}[WARN]${NC} %s\n" "$1"; }
error() {
  printf "${RED}[ERROR]${NC} %s\n" "$1" >&2
  exit 1
}

is_dotfiles_repo() {
  local dir="$1"
  [[ -f "$dir/setup.sh" && -f "$dir/.config/nix-darwin/flake.nix" ]]
}

current_script_dir() {
  local source_path="${BASH_SOURCE[0]:-$0}"

  if [[ -f "$source_path" ]]; then
    cd "$(dirname "$source_path")" && pwd
    return
  fi

  pwd
}

require_clean_mac_target() {
  [[ "$(uname -s)" == "Darwin" ]] || error "This bootstrap script only supports macOS."
  [[ "$(uname -m)" == "arm64" ]] || error "This dotfiles flake currently supports Apple Silicon macOS only."
}

load_nix_profile() {
  if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
    # shellcheck disable=SC1091
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi
}

ensure_nix() {
  if command -v nix >/dev/null 2>&1; then
    return
  fi

  info "Installing Nix with the Determinate installer..."
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix |
    sh -s -- install
  load_nix_profile

  command -v nix >/dev/null 2>&1 || error "Nix was installed but is not available in this shell."
}

run_git() {
  if command -v git >/dev/null 2>&1; then
    git "$@"
  else
    env NIX_CONFIG="$BOOTSTRAP_NIX_CONFIG" nix shell nixpkgs#git --command git "$@"
  fi
}

ensure_repo_clone() {
  local script_dir="$1"

  if is_dotfiles_repo "$script_dir"; then
    DOTFILES_DIR="$script_dir"
    return
  fi

  if [[ -d "$DOTFILES_DIR" ]]; then
    if ! is_dotfiles_repo "$DOTFILES_DIR"; then
      error "$DOTFILES_DIR already exists but does not look like this dotfiles repo."
    fi

    local origin_url
    origin_url="$(run_git -C "$DOTFILES_DIR" remote get-url origin 2>/dev/null || true)"
    case "$origin_url" in
      "$REPO_URL"|"git@github.com:huv1k/dotfiles.git")
        warn "Reusing existing dotfiles clone at $DOTFILES_DIR."
        ;;
      *)
        error "$DOTFILES_DIR exists, but its origin is '$origin_url' instead of $REPO_URL."
        ;;
    esac
  else
    info "Cloning dotfiles into $DOTFILES_DIR..."
    mkdir -p "$(dirname "$DOTFILES_DIR")"
    run_git clone "$REPO_URL" "$DOTFILES_DIR"
  fi

  info "Re-running setup from $DOTFILES_DIR..."
  exec bash "$DOTFILES_DIR/setup.sh"
}

backup_old_bare_repo() {
  local old_repo="$HOME/.config/dotfiles"

  if [[ -d "$old_repo" && ! -L "$old_repo" ]]; then
    local backup="${old_repo}.backup.$(date +%Y%m%d%H%M%S)"
    warn "Moving old bare dotfiles repo from $old_repo to $backup."
    mv "$old_repo" "$backup"
  fi
}

switch_nix_darwin() {
  local current_user current_uid current_home
  current_user="$(id -un)"
  current_uid="$(id -u)"
  current_home="$HOME"

  info "Applying nix-darwin configuration #$DARWIN_CONFIG..."
  sudo env \
    NIX_CONFIG="$BOOTSTRAP_NIX_CONFIG" \
    DOTFILES_USERNAME="$current_user" \
    DOTFILES_UID="$current_uid" \
    DOTFILES_HOME="$current_home" \
    nix run nix-darwin/master#darwin-rebuild -- switch \
    --flake "$DOTFILES_DIR/.config/nix-darwin#$DARWIN_CONFIG" \
    --impure
}

stow_dotfiles() {
  command -v stow >/dev/null 2>&1 || error "GNU Stow is not available after nix-darwin activation."

  info "Stowing dotfiles from $DOTFILES_DIR into $HOME..."
  if ! stow --restow -v -d "$(dirname "$DOTFILES_DIR")" -t "$HOME" "$(basename "$DOTFILES_DIR")"; then
    error "Stow conflicts detected. Resolve them manually, then re-run setup. To adopt existing files deliberately, run: stow --adopt -d $(dirname "$DOTFILES_DIR") -t $HOME $(basename "$DOTFILES_DIR")"
  fi
}

main() {
  require_clean_mac_target
  ensure_nix
  load_nix_profile
  ensure_repo_clone "$(current_script_dir)"
  backup_old_bare_repo
  switch_nix_darwin
  stow_dotfiles

  info "Done. Dotfiles are symlinked from $DOTFILES_DIR into $HOME."
}

main "$@"
