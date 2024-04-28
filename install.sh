#!/bin/bash 

# List of folders to simlink
ln -s ~/.dotfiles/config/nvim ~/.config/nvim
ln -s ~/.dotfiles/config/alacritty ~/.config/alacritty
ln -s ~/.dotfiles/config/waybar ~/.config/waybar
ln -s ~/.dotfiles/config/darktable ~/.config/darktable
ln -s ~/.dotfiles/config/wal ~/.config/wal
ln -s ~/.dotfiles/config/vis ~/.config/vis
ln -s ~/.dotfiles/config/dunst ~/.config/dunst
ln -s ~/.dotfiles/config/hypr ~/.config/hypr
ln -s ~/.dotfiles/config/zellij ~/.config/zellij

# List of files to simlink
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.p10k.zsh ~/.p10k.zsh
ln -s ~/.dotfiles/.p10k_simple.zsh ~/.p10k_simple.zsh
ln -s ~/.dotfiles/.p10k_complex.zsh ~/.p10k_complex.zsh
ln -s ~/.dotfiles/.zshrc.pre-oh-my-zsh ~/.zshrc.pre-oh-my-zsh
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig

# List of binaries to simlink
ln -s ~/.dotfiles/bin/batterynotify.sh ~/.local/bin
