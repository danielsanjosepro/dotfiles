#!/bin/bash

# Create an aur directory in the home directory
mkdir -p ~/aur

# Install dependencies
sudo pacman -Sy --noconfirm base-devel git

# Clone yay repository
git clone https://aur.archlinux.org/yay.git

# Change directory to yay
cd yay

# Build and install yay
makepkg -si --noconfirm