#!/usr/bin/env python3

import os

snap_packages = [
    "code --classic"
]

apt_packages = [
    "git",
    "darktable",
    "gimp",
]

for package in snap_packages:
    try:
        os.system(f"snap install {package}")
    except:
        print(f"Error installing {package}, skipping...")

for package in apt_packages:
    try:
        os.system(f"sudo apt install {package} -y")
    except:
        print(f"Error installing {package}, skipping...")
