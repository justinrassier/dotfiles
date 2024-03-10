DOTFILES=$HOME/dotfiles
#!/usr/bin/env zsh
STOW_FOLDERS="nvim,kitty,zsh,tmux,tmuxinator"


# Prerequisites 
#
# Oh My ZSH
#

# sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"


#nvm

# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash


# HOMEBREW
# xcode-select --install
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# brew update


# brew install neovim
# brew tap homebrew/cask-fonts && brew install font-Fira-Code-nerd-font
# brew install stow
 # brew install jesseduffield/lazygit/lazygit
 # brew install tmuxinator
 # brew install ripgrep

# Install packer

# git clone --depth 1 https://github.com/wbthomason/packer.nvim\
# ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Tmux Plugin Manager
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


# Install z for faster directory navigation
# git clone git@github.com:rupa/z.git git/z
 


pushd $DOTFILES
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
    stow -D $folder
    stow $folder
done
popd
