#!/usr/bin/env zsh
DOTFILES=$HOME/dotfiles
STOW_FOLDERS="nvim,kitty,zsh"

# nvim-lsp reference  (https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)
# efm is a general purpose language server (https://github.com/mattn/efm-langserver)
brew install efm-langserver

#  Install language servers needed from npm
npm install -g typescript typescript-language-server
npm install -g @angular/language-server@latest
npm install -g @tailwindcss/language-server

# eslint running as a daemon (probably not necessary)
npm install -g eslint_d



pushd $DOTFILES
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
    stow -D $folder
    stow $folder
done
popd
