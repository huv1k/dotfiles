# Dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/). The repo mirrors `~` directly — file paths in the repo match their location in the home directory.

## Install

```sh
git clone git@github.com:huv1k/dotfiles.git ~/Developer/dotfiles
cd ~/Developer/dotfiles
./setup.sh
```

## Usage

```sh
# Re-stow after changes
stow -d ~/Developer -t ~ dotfiles

# Adopt existing files (overwrite repo files with local ones, then symlink)
stow --adopt -d ~/Developer -t ~ dotfiles

# Remove all symlinks
stow -D -d ~/Developer -t ~ dotfiles
```
