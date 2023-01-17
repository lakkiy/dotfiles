return {
   use_fancy_tab_bar = false,
   tab_bar_at_bottom = true,
   hide_tab_bar_if_only_one_tab = true,

   keys = {
      {key="1", mods="ALT", action=wezterm.action{ActivateTab=0}},
      {key="2", mods="ALT", action=wezterm.action{ActivateTab=1}},
      {key="3", mods="ALT", action=wezterm.action{ActivateTab=2}},
      {key="4", mods="ALT", action=wezterm.action{ActivateTab=3}},
      {key="5", mods="ALT", action=wezterm.action{ActivateTab=4}},
      {key="6", mods="ALT", action=wezterm.action{ActivateTab=5}},
      {key="7", mods="ALT", action=wezterm.action{ActivateTab=6}},
      {key="8", mods="ALT", action=wezterm.action{ActivateTab=7}},
      {key="9", mods="ALT", action=wezterm.action{ActivateTab=-1}},
      {key="[", mods="ALT", action=wezterm.action{ActivateTabRelative=-1}},
      {key="]", mods="ALT", action=wezterm.action{ActivateTabRelative=1}},
   },
}
