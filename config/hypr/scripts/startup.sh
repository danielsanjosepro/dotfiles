#!/bin/bash
#
hyprctl --batch "dispatch exec [workspace 1 silent] GTK_THEME='Adwaita:dark' thunar; \
  dispatch exec [workspace 2 silent] firefox; \
  dispatch exec [workspace 3 silent] wezterm; \
  dispatch exec [workspace 5 silent] slack; \
  dispatch exec [workspace 6 silent] spotify;"

