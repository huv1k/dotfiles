# Dotfiles

Personal macOS dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/) and [nix-darwin](https://github.com/nix-darwin/nix-darwin).

The repo mirrors `$HOME` directly: paths in this repository match their final location under your home directory.

## Install on a clean Mac

Run this on an Apple Silicon Mac as your normal macOS user:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/huv1k/dotfiles/master/setup.sh)"
```

The installer will:

1. Install Nix with the Determinate installer if needed.
2. Clone this repo to `~/Developer/dotfiles`.
3. Apply the nix-darwin configuration at `~/Developer/dotfiles/.config/nix-darwin#huvik` using your current macOS account.
4. Stow the dotfiles into `$HOME`.

## Re-run setup

```sh
cd ~/Developer/dotfiles
./setup.sh
```

## Manual stow commands

```sh
# Re-stow after changes
stow --restow -d ~/Developer -t ~ dotfiles

# Adopt existing files deliberately
stow --adopt -d ~/Developer -t ~ dotfiles

# Remove all symlinks
stow -D -d ~/Developer -t ~ dotfiles
```
