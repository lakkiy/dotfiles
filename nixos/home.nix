# General home-manager config
{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    (import ../modules/tui.nix)
    (import ../modules/home/syncthing.nix)
  ];

  home.file."Pictures/wallpapers".source = ../modules/files/wallpapers;

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
