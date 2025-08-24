local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font("JetBrains Mono")
config.font_size = 18.0

config.enable_tab_bar = true
config.use_fancy_tab_bar = true

config.window_decorations = "RESIZE"

-- Load the tabline configuration
require("tabline")

return config
