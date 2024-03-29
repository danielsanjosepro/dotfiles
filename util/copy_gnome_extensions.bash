#!/usr/bin/env bash

# Set the source and destination paths
source="$HOME/.local/share/gnome-shell/extensions"
destination="$HOME/git/dotfiles/configs/gnome-shell/extensions"

# Copy the extensions to the destination directory
cp -r "$source" "$destination"
