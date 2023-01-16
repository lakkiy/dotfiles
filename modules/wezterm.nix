{ config, pkgs, ... }:

{
  programs.wezterm = {
    enable = ture;
  };

  home.file.".config/wezterm/wezterm.lua".source = ./files/wezterm.lua;
}
