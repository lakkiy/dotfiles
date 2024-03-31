# General home-manager config for NixOS
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../home-manager/shell
    ../home-manager/syncthing
  ];

  home.file."Pictures/wallpapers".source = ../files/wallpapers;

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
