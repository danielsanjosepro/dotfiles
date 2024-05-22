#!/bin/bash
#
hyprctl --batch "dispatch exec [workspace 1 silent] nautilus; \
  dispatch exec [workspace 2 silent] firefox; \
  dispatch exec [workspace 3 silent] alacritty; \
  dispatch exec [workspace 4 silent] zotero; \
  dispatch exec [workspace 5 silent] alacritty; \
  dispatch exec [workspace 6 silent] spotify; \
  dispatch exec [workspace 6 silent] alacritty -e vis; \
  dispatch exec [workspace 10 silent] darktable;"

