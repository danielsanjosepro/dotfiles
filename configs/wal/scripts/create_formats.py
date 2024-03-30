#!/usr/bin/env python3
import os
import json


def create_formats():
    """ This function creates colorschemes in different formats
    based on the colorschemes of wal """
    path = os.path.expanduser("~/.cache/wal/colors.json")
    data = json.load(open(path))
    special = data['special']
    colors = data['colors']
    # Hyprland format
    with open(os.path.expanduser("~/.cache/wal/colors-hyprland.conf"), "w") as f:
        # Format is
        # $color0 = aeaeae
        for i, special_color in enumerate(special):
            # Remove the hash and make lowercase
            color_without_hash = special[special_color][1:].lower()
            f.write(f'${special_color}Alpha = {color_without_hash}\n')
            f.write(f'${special_color} = 0xff{color_without_hash}\n')
        f.write("\n")
        for i, color in enumerate(colors):
            color_without_hash = colors[color][1:].lower()
            f.write(f'${color}Alpha = {color_without_hash}\n')
            f.write(f'${color} = 0xff{color_without_hash}\n')


if __name__ == "__main__":
    create_formats()
