# Dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Dotfiles live in `~/Developer/dotfiles` and are symlinked into `~`.

## Install

```sh
git clone https://github.com/huv1k/dotfiles ~/Developer/dotfiles
cd ~/Developer/dotfiles
./setup.sh
```

## Packages

| Package      | Contents                          |
| ------------ | --------------------------------- |
| `git`        | `.gitconfig`, `.gitignore`        |
| `tmux`       | `.tmux.conf`                      |
| `zsh`        | `.zshrc`                          |
| `fish`       | `.config/fish/`                   |
| `ghostty`    | `.config/ghostty/`                |
| `nix-darwin` | `.config/nix-darwin/`             |
| `zed`        | `.config/zed/`                    |
| `zellij`     | `.config/zellij/`                 |

## Usage

```sh
# Add a new dotfile
mv ~/.newfile ~/Developer/dotfiles/<package>/.newfile
cd ~/Developer/dotfiles && stow -t ~ <package>

# Remove symlinks for a package
stow -D -t ~ <package>

# Re-stow after changes
stow -R -t ~ <package>
```
