{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.hyprland;
in {
  options.my.hyprland = {
    enable = mkEnableOption "hyprland";
  };

  config = mkIf cfg.enable {
    # Status bar
    programs.ags = {
      enable = true;
      configDir = ../../static/ags;
      extraPackages = with pkgs; [
        # additional packages to add to gjs's runtime
        gtksourceview
        webkitgtk
        accountsservice
      ];
    };

    # A notification daemon
    services.dunst.enable = true;

    # Application launcher
    programs.bemenu.enable = true;

    # Lock screen
    programs.hyprlock.enable = true;

    home.file.".config/hypr/hyprpaper.conf".source = ../../static/hypr/hyprpaper.conf;
    home.file.".local/share/icons/Bibata-Modern-Ice".source = ../../static/Bibata-Modern-Ice;

    home.packages = with pkgs; [
      # clipboard for wayland, also needed by other tools like hyprpicker
      # to paste color to clipboard
      # provide command: wl-copy, wl-paste
      wl-clipboard

      # switch to application or run it
      wlrctl

      # screenshot
      grim
      slurp

      # echo tools
      hyprpaper
      hyprpicker
      hyprcursor

      # voice control
      pavucontrol

      # network manager on tray
      networkmanagerapplet

      # bluetooth manager
      blueberry

      # cursor theme for x
      bibata-cursors

      # Automatically Mounting
      # udiskie is a udisks2 front-end that allows to manage removable
      # media such as CDs or flash drives from userspace.
      udiskie
    ];

    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        env = [
          # Fix cursor don't show with Nvidia card
          "WLR_NO_HARDWARE_CURSORS,1"

          # hyprcursor
          "HYPRCURSOR_THEME,Bibata-Modern-Ice"
          "HYPRCURSOR_SIZE,32"
          "XCURSOR_THEME,Bibata-Modern-Ice"
          "XCURSOR_SIZE,32"
        ];

        exec-once = [
          "hyprctl setcursor Bibata-Modern-Ice 32"

          # status bar
          "ags -b hypr"
          "nm-applet --indicator"

          # input method
          "fcitx5 -d"

          # auto mount usb
          "udiskie &"

          # wallpaper
          "hyprpaper"
        ];

        monitor = [
          "desc:Sony SDMU27M90*30 9706757,3840x2160@144,0x0,2.0,bitdepth,10"
          "desc:HFC X24 Pro demoset-1,3840x2160,1920x0,2.0,transform,3"
          "desc:LZT Viewedge.CR   00000000,preferred,1440x2440,auto,transform,3"
        ];

        workspace = [
          "1, monitor:desc:Sony SDMU27M90*30 9706757, default:true"
          "2, monitor:desc:Sony SDMU27M90*30 9706757"
          "3, monitor:desc:Sony SDMU27M90*30 9706757"
          "4, monitor:desc:HFC X24 Pro demoset-1, default: true"
          "5, monitor:desc:HFC X24 Pro demoset-1"
          "6, monitor:desc:HFC X24 Pro demoset-1"
          "7, monitor:desc:HFC X24 Pro demoset-1"
          "8, monitor:desc:HFC X24 Pro demoset-1"
          "9, monitor:desc:LZT Viewedge.CR   00000000, default: true"
          "10, monitor:desc:LZT Viewedge.CR   00000000"
        ];

        windowrule = let
          f = regex: "float, ^(${regex})$";
        in
          [
            (f "pavucontrol")
            (f "bluetooth")
            (f "nm-connection-editor")
            (f "org.gnome.Settings")
            (f "org.gnome.design.Palette")
            (f "Color Picker")
            (f "xdg-desktop-portal")
            (f "xdg-desktop-portal-gnome")
            (f "qbittorrent")
            (f "com.github.Aylur.ags")
            "noblur,^(?!emacs$|fuzzel|foot$).*$"
          ]
          ++ [
            "float, title:(emacs-run-launcher)"
          ];

        general = {
          layout = "dwindle";
          resize_on_border = true;
          border_size = 5;
          "col.active_border" = "0xffb072d1";
          "col.inactive_border" = "0xff292a37";
        };

        input = {
          kb_variant = "dvorak";
          repeat_rate = 60;
          repeat_delay = 150;
          touchpad.natural_scroll = "yes";
        };

        decoration.rounding = 5;
        gestures.workspace_swipe = "on";

        bind = let
          binding = mod: cmd: key: arg: "${mod}, ${key}, ${cmd}, ${arg}";
          mvfocus = binding "SUPER" "movefocus";
          ws = binding "SUPER" "workspace";
          resizeactive = binding "SUPER CTRL" "resizeactive";
          mvactive = binding "SUPER ALT" "moveactive";
          mvtows = binding "SUPER SHIFT" "movetoworkspace";
          mvw = binding "SUPER SHIFT" "movewindow";
          arr = [1 2 3 4 5 6 7 8 9];
        in
          [
            # Launcher
            "SUPER, D, exec, bemenu-run -i --fn 'Sarasa Gothic SC 20'"

            # Applications (hyprctl clients | grep class)
            "SUPER, Return, exec, wlrctl window focus foot || foot"
            # "SUPER, B, exec, wlrctl window focus firefox || firefox"
            "SUPER, B, exec, wlrctl window focus zen || zen-alpha"
            "SUPER, E, exec, wlrctl window focus emacs || emacs"

            # Lock screen
            "SUPER, L, exec, hyprlock --immediate -q"

            # Screenshot
            "SUPER_SHIFT, p, exec, grim -g \"$(slurp -d)\" - | wl-copy"
            " , Print, exec, grim -g \"$(slurp -d)\" - | wl-copy"

            # Start/Stop Recording
            "SUPER,F10,pass,^(com\.obsproject\.Studio)$"

            # hyprland
            "ALT, Tab, focuscurrentorlast"
            "SUPER, Q, killactive"
            "SUPER, F, togglefloating"
            "SUPER_SHIFT, F, fullscreen"
            "SUPER, P, togglesplit"

            # tabbed
            "SUPER, G, togglegroup"

            # scratchpad
            "SUPER, C, movetoworkspace, special"
            "SUPER_SHIFT, C, togglespecialworkspace"

            (mvw "h" "l")
            (mvw "s" "r")
            (mvw "t" "u")
            (mvw "n" "d")
            (mvfocus "h" "l")
            (mvfocus "s" "r")
            (mvfocus "t" "u")
            (mvfocus "n" "d")
            (ws "left" "e-1")
            (ws "right" "e+1")
            (mvtows "left" "e-1")
            (mvtows "right" "e+1")
            (resizeactive "n" "0 -20")
            (resizeactive "t" "0 20")
            (resizeactive "s" "20 0")
            (resizeactive "h" "-20 0")
            (mvactive "n" "0 -20")
            (mvactive "t" "0 20")
            (mvactive "s" "20 0")
            (mvactive "h" "-20 0")
          ]
          ++ (map (i: ws (toString i) (toString i)) arr)
          ++ (map (i: mvtows (toString i) (toString i)) arr);

        bindm = [
          "SUPER, mouse:273, resizewindow"
          "SUPER, mouse:272, movewindow"
        ];
      };
    };
  };
}
