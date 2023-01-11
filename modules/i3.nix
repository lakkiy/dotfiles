{ lib, config, pkgs, ... }:

let
  mod = "Mod4";
in
{
  imports = [
    ./kitty.nix
  ];

  home.packages = with pkgs; [
    ly # TUI display manager, systemctl enable ly.service
    dmenu
    wmctrl
  ];

  services = {
    betterlockscreen.enable = true;
    flameshot.enable = true;
    network-manager-applet.enable = true;
    picom = {
      enable = true;
      package = pkgs.picom-jonaburg;
    };
  };

  xsession.enable = true;
  # startx .nix-profile/bin/i3 or add this to .xinitrc
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = mod;
      terminal = "kitty";
      menu = "dmenu_run -b";

      fonts = {
        names = [ "IBM Plex Mono" ];
      };

      window = {
        border = 0;
      };

      gaps = {
        inner  = 10;
        outer  = 0;
        top    = 0;
        bottom = 0;
      };

      bars = [
        {
          fonts = {
            names = [ "IBM Plex Mono" ];
          };
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs";
        }
      ];

      startup = [
        { command = "xset r rate 150 60"; }
        { command = "xrdb -merge ~/.Xresources"; }
        { command = "feh --bg-fill --randomize ~/.local/share/backgrounds/*"; always = true; }
        { command = "betterlockscreen -u ~/.local/share/backgrounds/"; always = true; }
        { command = "dropbox start"; }
        { command = "crow"; }
        { command = "firefox"; }
        { command = "fcitx5 -d"; }
        { command = "flameshot"; }
        { command = "nm-applet"; }
        { command = "picom --experimental-backend"; }
      ];

      keybindings = lib.mkOptionDefault {
        "${mod}+Return"  = "exec wmctrl -xa kitty || kitty";
        "${mod}+l"       = "exec betterlockscreen -l dimblur";
        "${mod}+Shift+p" = "exec flameshot gui";

        "${mod}+h" = "focus left";
        "${mod}+t" = "focus down";
        "${mod}+n" = "focus up";
        "${mod}+s" = "focus right";

        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+t" = "move down";
        "${mod}+Shift+n" = "move up";
        "${mod}+Shift+s" = "move right";

        "${mod}+v" = "split toggle";

        "${mod}+g" = "layout stacking";
        "${mod}+c" = "layout tabbed";
        "${mod}+r" = "layout toggle split";

        # My multi monitor setup
        # "${mod}+m" = "move workspace to output DP-2";
        # "${mod}+Shift+m" = "move workspace to output DP-5";
      };
    };

  };

  programs = {
    feh = {
      enable = true;
    };
    i3status-rust = {
      enable = true;
      bars.bottom.blocks = [
        {
          block = "focused_window";
          max_width = 50;
          show_marks = "visible";
        }
        {
          block = "disk_space";
          path = "/";
          alias = "/";
          info_type = "available";
          unit = "GB";
          interval = 20;
          warning = 20.0;
          alert = 10.0;
        }
        {
          block = "memory";
          display_type = "memory";
          format_mem = "{mem_used_percents}";
          format_swap = "{swap_used_percents}";
        }
        {
          block = "cpu";
          interval = 1;
        }
        {
          block = "load";
          interval = 1;
          format = "{1m}";
        }
        {
          block = "sound";
        }
        {
          block = "time";
          interval = 5;
          format = "%a %d/%m %R";
        }
      ];
    };
  };
}
