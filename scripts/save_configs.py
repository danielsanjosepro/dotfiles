#!/bin/python3

import os


home_dir = os.path.expanduser("~")

config_directories = [
    "dunst",
    "hypr",
    "waybar",
    "nvim",
    "alacritty",
    "darktable",
]

# We replace for each of this folders the config directories with the ones
# used in this system
for config_dir in config_directories:
    # We first check if the directory exists
    print(f"Saving configuration for {config_dir}")
    if not os.path.isdir(f"{home_dir}/.config/{config_dir}"):
        print(f"Directory {config_dir} does not exist")
        continue
    os.system(f"cp -r {home_dir}/.config/{config_dir} ~/git/dotfiles/configs/")
