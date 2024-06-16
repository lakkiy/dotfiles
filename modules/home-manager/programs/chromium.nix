{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.my.chromium;

in {
  options.my.chromium = {
    enable = mkEnableOption "chromium";
  };

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      commandLineArgs = [
        # https://wiki.archlinux.org/title/chromium#Native_Wayland_support
        # For linux waylany 4k monitor 150% scale
        "--ozone-platform-hint=auto"
        # Make fcitx work under wayland
        "--gtk-version=4"
      ];
    };
  };
}
