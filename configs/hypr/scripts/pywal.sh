#!/bin/bash
wal -q -i ~/Pictures/Wallpaper/

source ~/.cache/wal/colors.sh
python3 ~/.config/wal/scripts/create_formats.py

# Copy color file to respective directories
cp ~/.cache/wal/colors-waybar.css ~/.config/waybar/
cp ~/.cache/wal/colors-hyprland.conf ~/.config/hypr/themes/
# Reaload waybar
source ~/.config/waybar/launch.sh > /dev/null 2>&1 &
# Reload hypr
# TODO
# Run pyfox
pywalfox update
# Restart dunst
killall dunst
dunst -conf ~/.config/dunst/dunstrc &
# Update cli-visualizer
source ~/.config/vis/reload_colors.sh &

# Get wallpaper name
wallpaper=$(basename $(cat ~/.cache/wal/wal))

# Set wallpaper
swww img ~/Pictures/Wallpaper/$wallpaper --transition-step 90 --transition-type wipe --transition-angle 30

cp ~/Pictures/Wallpaper/$wallpaper ~/.cache/wallpaper.png
