local wezterm = require("wezterm")
local config = wezterm.config_builder()

local font = wezterm.font_with_fallback({
	{ family = "Hack Nerd Font", style = "Normal", scale = 1 },
	{ family = "Cambria Math", scale = 1.0 },
})
config.font_size = 18.0

config.enable_tab_bar = true
config.enable_wayland = false
config.use_fancy_tab_bar = true

config.window_decorations = "RESIZE"

-- Load the tabline configuration
require("tabline")

return config
