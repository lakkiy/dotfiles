{ lib, config, pkgs, inputs, ... }:

{
  # automatically change dark mode and light mode on linux desktop
  services.darkman = {
    enable = true;
    # beijing
    settings = {
      lat = 39.9;
      lng = 116.3;
    };
  };

  services.swayidle.enable = true;

  programs.wlogout = {
    enable = true;
    layout = [
      {label = "lock"; action = "swaylock"; text = "Lock";}
      {label = "hibernate"; action = "systemctl hibernate"; text = "Hibernate";}
      {label = "logout"; action = "hyprctl dispatch exit 0"; text = "Logout";}
      {label = "shutdown"; action = "systemctl poweroff"; text = "Shutdown";}
      {label = "suspend"; action = "systemctl suspend"; text = "Suspend";}
      {label = "reboot"; action = "systemctl reboot"; text = "Reboot";}
    ];
  };

  home.file.".config/ags" = {
    source = ../files/ags;
    recursive = true;
  };

  home.packages = with pkgs; [
    grimblast            # screenshot
    wl-clipboard         # copy to clipboard
    wlrctl               # switch to application or run it
    wl-gammactl          # Contrast, brightness, and gamma adjustments
    hyprpicker           # color picker for wayland
    swappy               # snapshot editing
    imagemagick          # for bitmap images
    brightnessctl        # control device brightness
    inotify-tools        # for ags
    pwvucontrol          # pipewire volume control, replace pavucontrol
    swww                 # wallpaper
    bemenu               # application launcher
    networkmanagerapplet # network manager applet on tray
    blueberry            # bluetooth manager
    pkgs.bibata-cursors  # cursor theme

    ags
    libsoup_3
  ];

  # for now only use home-manager to config hyprland
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      env = [
        # Fix cursor don't show with Nvidia card
        "WLR_NO_HARDWARE_CURSORS,1"
      ];

      exec-once = [
        "nm-applet --indicator & fcitx5 -d"
        "swayidle -w timeout 1800 'systemctl suspend'"
        "emacs --daemon"
        "hyprctl setcursor Bibata-Modern-Amber 32"
        # https://github.com/Horus645/swww/issues/100
        "swww init && swww img '$HOME/Pictures/wallpapers/default.jpg' -o DP-2 & swww img '$HOME/Pictures/wallpapers/v/default.jpg' -o DP-3"
        "ags -b hypr"
        "udiskie &"
      ];

      monitor = [
        "DP-2,3840x2160@144,1440x0,1.5,bitdepth,10"
        "DP-3,3840x2160,0x0,1.5,transform,1"
        "HDMI-A-2,preferred,1440x2440,auto,transform,3"
      ];
      workspace = [
        "1, monitor:DP-2, default:true"
        "2, monitor:DP-2"
        "3, monitor:DP-3"
        "4, monitor:DP-3"
        "5, monitor:DP-2"
        "6, monitor:DP-2"
        "7, monitor:DP-3"
        "8, monitor:DP-3"
        "9, monitor:HDMI-A-2"
        "10, monitor:HDMI-A-2"
      ];

      windowrule = let
        f = regex: "float, ^(${regex})$";
      in [
		    (f "org.gnome.Nautilus")
		    (f "pwvucontrol")
		    (f "nm-connection-editor")
		    (f "org.gnome.Settings")
		    (f "org.gnome.design.Palette")
		    (f "Color Picker")
		    (f "xdg-desktop-portal")
		    (f "xdg-desktop-portal-gnome")
		    (f "qbittorrent")
		    (f "com.github.Aylur.ags")
		    "workspace 7, title:Spotify"
        "noblur,^(?!emacs$|xterm|fuzzel$).*$"
      ];

      general = {
        layout = "dwindle";
        resize_on_border = true;
      };

      input = {
        kb_layout = "us";
        kb_variant = "dvorak";
        follow_mouse = 1;
        repeat_rate = 60;
        repeat_delay = 150;
        touchpad = {
          natural_scroll = "yes";
          disable_while_typing = true;
          drag_lock = true;
        };
      };

      gestures = {
        workspace_swipe = "on";
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        layers_hog_keyboard_focus = true;
        disable_splash_rendering = true;
      };

      decoration = {
        drop_shadow = "yes";
        shadow_range = 8;
        shadow_render_power = 2;
        "col.shadow" = "rgba(00000044)";

        dim_inactive = false;

        blur = {
          enabled = true;
          size = 8;
          passes = 3;
          new_optimizations = "on";
          noise = 0.01;
          contrast = 0.9;
          brightness = 0.8;
        };
      };

      animations = {
        enabled = "yes";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
      };

      bind = let
        binding = mod: cmd: key: arg: "${mod}, ${key}, ${cmd}, ${arg}";
        mvfocus = binding "SUPER" "movefocus";
        ws = binding "SUPER" "workspace";
        resizeactive = binding "SUPER CTRL" "resizeactive";
        mvactive = binding "SUPER ALT" "moveactive";
        mvtows = binding "SUPER SHIFT" "movetoworkspace";
        mvw = binding "SUPER SHIFT" "movewindow";
        arr = [1 2 3 4 5 6 7 8 9];
      in [
        "SUPER, Return, exec, wlrctl window focus xterm || xterm"
        "SUPER, B, exec, wlrctl window focus firefox || firefox"
        "SUPER, E, exec, wlrctl window focus emacs || emacs"
        "SUPER, D, exec, bemenu-run -i --fn 'Sarasa Gothic SC 20'"
        "SUPER_SHIFT, P, exec, grimblast copysave area"
        # TODO scratch pad, tab layout
        # "bind = SUPER_SHIFT, c, movetoworkspace, special"
        # "bind = SUPER , c, togglespecialworkspace,"


        "ALT, Tab, focuscurrentorlast"
        "SUPER, Q, killactive"
        "SUPER, F, togglefloating"
        "SUPER, G, fullscreen"
        "SUPER, O, fakefullscreen"
        "SUPER, P, togglesplit"

        (mvw "h" "l") (mvw "s" "r") (mvw "t" "u") (mvw "n" "d")
        (mvfocus "h" "l") (mvfocus "s" "r") (mvfocus "t" "u") (mvfocus "n" "d")
        (ws "left" "e-1") (ws "right" "e+1")
        (mvtows "left" "e-1") (mvtows "right" "e+1")
        (resizeactive "n" "0 -20") (resizeactive "t" "0 20") (resizeactive "s" "20 0") (resizeactive "h" "-20 0")
        (mvactive "n" "0 -20") (mvactive "t" "0 20") (mvactive "s" "20 0") (mvactive "h" "-20 0")
      ]
      ++ (map (i: ws (toString i) (toString i)) arr)
      ++ (map (i: mvtows (toString i) (toString i)) arr);

      bindm = [
        "SUPER, mouse:273, resizewindow"
        "SUPER, mouse:272, movewindow"
      ];
    };
  };
}
