#!usr/bin/bash
#
#
# This script is used to launch vis or reload it
#

# copy the color scheme to the vis directory
cp ~/.cache/wal/cli-visualizer ~/.config/vis/colors/cli-visualizer
python3 ~/.config/vis/sort_by_hue.py  # Sort colors by hue in the color scheme

# Check if vis is already running
# If it is, reload it
if pgrep -x "vis" > /dev/null
then
  killall -USR1 vis
fi
