
-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.hide_tab_bar_if_only_one_tab = true
config.font = wezterm.font 'Hack'
config.window_padding = {
  left = 2,
  right = 2,
  top = 2,
  bottom = 2,
}

-- and finally, return the configuration to wezterm
return config
