{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.my.wezterm;

in {
  options.my.wezterm = {
    enable = mkEnableOption "wezterm";
  };

  config = mkIf cfg.enable {
    xdg.configFile.wezterm.source = ../../../static/wezterm;
    home.packages = [ pkgs.wezterm ];
  };
}
