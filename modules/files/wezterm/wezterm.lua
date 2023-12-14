return {
   color_schemes = {
      ["Gnome Light"] = require("gnome"),
      ["Charmful Dark"] = require("charmful"),
   },
   color_scheme = "Charmful Dark",
   hide_tab_bar_if_only_one_tab = true,
   default_cursor_style = 'BlinkingBar',
   window_close_confirmation = "NeverPrompt",
   enable_scroll_bar = false;

   window_padding = {
      top    = '0.5cell',
      right  = '1cell',
      bottom = '0.5cell',
      left   = '1cell',
   },

   inactive_pane_hsb = {
      saturation = 0.9,
      brightness = 0.8,
   },

   window_background_opacity = 1.0,
   text_background_opacity = 1.0,

   keys = require('keys')
}
