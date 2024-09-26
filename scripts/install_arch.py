#!/usr/bin/env python3

import os

pacman_packages = [
    "git",
    "darktable",
    "gimp",
    "python-numpy",
    "python-matplotlib",
    "python-pandas",
    "python-scipy",
    "hyprpaper",
]

yay_packages = [
    # "visual-studio-code-bin",
    "python-pip",
    "python-pywal",
    "brightnessctl",
    "waybar",
    "pamixer",
    "unzip",
    "flatpak",
    "wl-clipboard",
    "hyprlock",
    "hypridle",
    "bluez",  # Bluetooth support
    "bluez-utils",
    "blueman",
    "qt5-wayland",  # qt support for wayland
    "qt6-wayland",
    "dunst",  # Notification daemon
    "xournal",  # PDF annotation
    "checkupdates",  # Check for updates
    "grim",  # Screenshot utility
    "slurp",  # Select region for grim
    "zsh",  # Zsh shell
    "zsh-autosuggestions",  # Zsh autosuggestions
    "pavucontrol",  # Pulseaudio volume control
    "ripgrep",  # Ripgrep for fast searching
    "zoxide",  # Directory jumping
]

for package in pacman_packages:
    try:
        os.system(f"sudo pacman -S {package} --noconfirm")
    except Exception as e:
        print(f"Error {e} installing {package}, skipping...")

for package in yay_packages:
    try:
        os.system(f"yay -S {package} --noconfirm")
    except Exception as e:
        print(f"Error {e} installing {package}, skipping...")
