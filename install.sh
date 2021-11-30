DOTFILES=$HOME/dotfiles
#!/usr/bin/env zsh
STOW_FOLDERS="nvim,kitty,zsh"

# Prerequisites I don't want to just do all the time
#
# Oh My ZSH
#

# sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


#Nvim
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash


# HOMEBREW
#xcode-select --install
#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
#brew update


#brew install neovim
#brew tap homebrew/cask-fonts && brew install font-Fira-Code-nerd-font
#brew install stow

#
#
# Vim Plug (https://github.com/junegunn/vim-plug)
#
 
# curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
#    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

 
 # nvim-lsp reference  (https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md)
 
 #  Install language servers needed from npm
npm install -g typescript typescript-language-server
npm install -g @angular/language-server@latest
npm install -g @tailwindcss/language-server
npm install -g vscode-langservers-extracted
npm i -g vscode-langservers-extracted

 

 # # ripgrep is used by some plugins for searching
brew install ripgrep



pushd $DOTFILES
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
    stow -D $folder
    stow $folder
done
popd
