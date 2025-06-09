#!/usr/bin/env python3

import os

pacman_packages = [
    "git",
    "darktable",
    "gimp",
]

yay_packages = [
    "blueman",
    "bluez",  # Bluetooth support
    "bluez-utils",
    "brightnessctl",
    "checkupdates",  # Check for updates
    "dunst",  # Notification daemon
    "eza",
    "fish",
    "flatpak",
    "fzf",
    "grim",  # Screenshot utility
    "hypridle",
    "hyprlock",
    "i3status-rust",
    "npm",
    "pamixer",
    "pavucontrol",  # Pulseaudio volume control
    "python-pip",
    "python-pywal",
    "qt5-wayland",  # qt support for wayland
    "qt6-wayland",
    "ripgrep",  # Ripgrep for fast searching
    "slurp",  # Select region for grim
    "unzip",
    "waybar",
    "wl-clipboard",
    "xournal",  # PDF annotation
    "xsel",
    "zoxide",  # Directory jumping
    "zsh",  # Zsh shell
    "zsh-autosuggestions",  # Zsh autosuggestions
    # "visual-studio-code-bin",
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
