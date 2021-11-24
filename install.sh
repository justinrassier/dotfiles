#!/usr/bin/env zsh
DOTFILES=$HOME/dotfiles
STOW_FOLDERS="nvim,kitty,zsh"

# Prerequisites I don't want to just do all the time
#
# HOMEBREW
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew update


brew install neovim
brew install --cask font-fira-code-nerd-font
brew install stow
#
#
# Vim Plug (https://github.com/junegunn/vim-plug)
#
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
 
 
 # nvim-lsp reference  (https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)
 
 #  Install language servers needed from npm
npm install -g typescript typescript-language-server
npm install -g @angular/language-server@latest
npm install -g @tailwindcss/language-server
npm install -g vscode-langservers-extracted
 

 # # ripgrep is used by some plugins for searching
brew install ripgrep



pushd $DOTFILES
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
    stow -D $folder
    stow $folder
done
popd
