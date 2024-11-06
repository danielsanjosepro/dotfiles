#!/bin/bash 

# Get the directory of the script
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# List of folders to simlink
CONFIG_LIST=(
    dunst
    hypr 
    kitty 
    nvim 
    darktable 
    waybar 
    vis 
    zellij
)

CONFIG_DIR=~/.config

for NAME in ${CONFIG_LIST[@]}; do
    ln -s -f $DOTFILES_DIR/config/$NAME $CONFIG_DIR/$NAME 
done

# List of files to simlink
ln -s -f $DOTFILES_DIR/zsh/.zshrc ~/.zshrc
ln -s -f $DOTFILES_DIR/zsh/.p10k.zsh ~/.p10k.zsh
ln -s -f $DOTFILES_DIR/zsh/.p10k_simple.zsh ~/.p10k_simple.zsh
ln -s -f $DOTFILES_DIR/zsh/.p10k_complex.zsh ~/.p10k_complex.zsh
ln -s -f $DOTFILES_DIR/zsh/.zshrc.pre-oh-my-zsh ~/.zshrc.pre-oh-my-zsh

ln -s -f $DOTFILES_DIR/.gitconfig ~/.gitconfig
ln -s -f $DOTFILES_DIR/.bash_prompt ~/.bash_prompt
