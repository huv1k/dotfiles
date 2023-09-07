# Dotfiles

It works by a git bare repository hosted within `~/.config/dotfiles` with
a working directory of `~`.

To install:

```sh
git clone https://github.com/huv1k/dotfiles --bare ~/.config/dotfiles
git --git-dir=$HOME/.config/dotfiles/ --work-tree=$HOME config --local status.showUntrackedFiles no
git --git-dir=$HOME/.config/dotfiles/ --work-tree=$HOME checkout
```

This setup is heavily inspired by https://github.com/leebyron/dotfiles.
