# Script that gets the layout of the current workspace and prints it to the
# console

import os
import json


def get_layout():
    cmd = "hyprctl devices -j"
    devices = os.popen(cmd).read()
    devices_json = json.loads(devices)

    for keyboard in devices_json["keyboards"]:
        if keyboard["name"] == "at-translated-set-2-keyboard":
            active_keymap: str = keyboard["active_keymap"]
            if active_keymap.find("German") != -1:
                print("de")
            elif active_keymap.find("US") != -1:
                print("us")


if __name__ == "__main__":
    get_layout()
