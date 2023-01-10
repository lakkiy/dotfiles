{ config, pkgs, ... }:

{
  # TODO
  xsession.windowManager.i3 = {
    enable = true;
    # config = {
    #   keybindings = {

    #   };
    # };
  };
  home.file.".config/i3/config".source = ./files/config

  services = {
    betterlockscreen.enable = true;
    flameshot.enable = true;
    network-manager-applet.enable = true;
  };

  programs = {
    feh = {
      enable = true;
    };
    i3status-rust = {
      enable = true;
      bottom.blocks = [
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
      ]
    };
  };

  home.packages = with pkgs; [
    ly # TUI display manager
    dmenu
    wmctl
  ];
}
