#!/bin/bash

mkdir -p ~/Pictures

# open screenshot tool
scrot -s -q 100 -o ~/Pictures/screenshot.png

# play a "Camera shutter" sound
paplay /usr/share/sounds/freedesktop/stereo/screen-capture.oga &

# remove outer pixel rows because they sometimes include the capture border
mogrify -crop +1+1 -crop -1-1 +repage ~/Pictures/screenshot.png

# copy to clipboard
xclip -sel clip -t image/png -i ~/Pictures/screenshot.png
