# General home-manager config for NixOS
{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    (import ../modules/tui.nix)
    (import ../modules/home/syncthing.nix)
  ];

  home.file."Pictures/wallpapers".source = ../modules/files/wallpapers;

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
