#!/bin/bash
# Make sure that the Screenshot directory exists
mkdir ~/Pictures/Screenshots

# Take a screenshot of the current window and save it to the desktop
grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +%s).png | wl-copy -t image/png 
