# General home-manager config
{ config, lib, pkgs, ... }:

{
  imports = [
    (import ../modules/tui.nix)
    (import ../modules/home/syncthing.nix)
  ];

  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
