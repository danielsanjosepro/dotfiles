#!/bin/bash
# Script to toggle the hypridle daemon on and off
# We first check if the hypridle daemon is running
# If it is, we kill it and exit
# If it isn't, we start it and exit

if pgrep -x "hypridle" > /dev/null
then
    echo "Hypridle is running, killing it"
    pkill hypridle
else
    echo "Hypridle is not running, starting it"
    hypridle > /dev/null & 
fi
