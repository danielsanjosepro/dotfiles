#!/usr/bin/env bash
# Assign workspaces 2 and 3 to the connected external monitor.
# Falls back to the internal (eDP-*) display when no external monitor is connected.

set -euo pipefail

internal=""
external=""

while IFS= read -r name; do
  if [[ "$name" == eDP-* ]]; then
    internal="$name"
  elif [[ -z "$external" ]]; then
    external="$name"
  fi
done < <(hyprctl monitors | awk '/^Monitor / { print $2 }')

target="${external:-$internal}"
[[ -z "$target" ]] && exit 0

hyprctl keyword workspace "2,monitor:${target},default:true" >/dev/null
hyprctl keyword workspace "3,monitor:${target}" >/dev/null
