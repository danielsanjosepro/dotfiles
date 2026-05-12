#!/bin/bash
# Make sure that the Screenshot directory exists
mkdir -p ~/Pictures/Screenshots

# Take a screenshot of a selected region, save it, and copy to clipboard
FILE=~/Pictures/Screenshots/$(date +%s).png
grim -g "$(slurp)" "$FILE" && wl-copy -t image/png < "$FILE"
