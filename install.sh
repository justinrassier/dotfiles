#!/usr/bin/env zsh

DOTFILES=$HOME/dotfiles
STOW_FOLDERS="nvim,kitty,zsh"

pushd $DOTFILES
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
    stow -D $folder
    stow $folder
done
popd
