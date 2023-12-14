local wezterm = require("wezterm")
local wa = wezterm.action

wezterm.on("padding-off", function(window)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_padding then
		overrides.window_padding = {
			top = "0",
			right = "0",
			bottom = "0",
			left = "0",
		}
	else
		overrides.window_padding = nil
	end
	window:set_config_overrides(overrides)
end)

wezterm.on("toggle-opacity", function(window)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 0.8
	else
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)

wezterm.on("toggle-darkmode", function(window)
	local overrides = window:get_config_overrides() or {}
	if overrides.color_scheme == "Gnome Light" then
		overrides.color_scheme = "Charmful Dark"
	else
		overrides.color_scheme = "Gnome Light"
	end
	window:set_config_overrides(overrides)
end)

return {
  { key = '[', mods = 'ALT', action = wa.ActivateTabRelative(-1) },
  { key = ']', mods = 'ALT', action = wa.ActivateTabRelative(1) },
  { key = 'LeftArrow',  mods = 'ALT', action = wa.ActivateTabRelative(-1) },
  { key = 'RightArrow', mods = 'ALT', action = wa.ActivateTabRelative(1) },
  { key = 'LeftArrow',  mods = 'CTRL|SHIFT', action = wa.ActivateTabRelative(-1) },
  { key = 'RightArrow', mods = 'CTRL|SHIFT', action = wa.ActivateTabRelative(1) },
  { key = '1', mods = 'ALT', action = wa.ActivateTab(0) },
  { key = '2', mods = 'ALT', action = wa.ActivateTab(1) },
  { key = '3', mods = 'ALT', action = wa.ActivateTab(2) },
  { key = '4', mods = 'ALT', action = wa.ActivateTab(3) },
  { key = '5', mods = 'ALT', action = wa.ActivateTab(4) },
  { key = '6', mods = 'ALT', action = wa.ActivateTab(5) },
  { key = '7', mods = 'ALT', action = wa.ActivateTab(6) },
  { key = '8', mods = 'ALT', action = wa.ActivateTab(7) },
  { key = '9', mods = 'ALT', action = wa.ActivateTab(8) },
  { key = '0', mods = 'ALT', action = wa.ActivateTab(-1) },
  { key = "p", mods = "CTRL|SHIFT", action = wa.EmitEvent("padding-off") },
  { key = "o", mods = "CTRL|SHIFT", action = wa.EmitEvent("toggle-opacity") },
  { key = "i", mods = "CTRL|SHIFT", action = wa.EmitEvent("toggle-darkmode") },
}
