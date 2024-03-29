#!/usr/bin/env python3
import os
import time


def toggle_fullscreen():
    result = os.popen('hyprctl activewindow | grep "fullscreen: 1"').read()
    print(result)
    is_fullscreen = result != ''
    print(is_fullscreen)
    if is_fullscreen:
        print("Is fullscreen")
        os.system('pkill waybar')
        time.sleep(0.1)
        os.system('hyprctl dispatch fullscreen')
    else:
        print("Is not fullscreen")
        os.system('source ~/.config/waybar/launch.sh')
        time.sleep(0.1)
        os.system('hyprctl dispatch fullscreen')


if __name__ == '__main__':
    toggle_fullscreen()
