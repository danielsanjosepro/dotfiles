#!/bin/sh
#  _                            _     
#| |                          | |    
#| |     __ _ _   _ _ __   ___| |__  
#| |    / _` | | | | '_ \ / __| '_ \ 
#| |___| (_| | |_| | | | | (__| | | |
#\_____/\__,_|\__,_|_| |_|\___|_| |_|
# waybar

killall waybar

waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style.css
