{ pkgs, ... }:

{
  programs.wezterm.enable = true;
  xdg.configFile.wezterm.source = ../files/wezterm;
}
