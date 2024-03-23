# General home-manager config for NixOS
{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    (import ../home-manager/shell.nix)
    (import ../home-manager/syncthing.nix)
  ];

  home.file."Pictures/wallpapers".source = ../files/wallpapers;

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
