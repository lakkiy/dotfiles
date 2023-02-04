# General home-manager config
{ config, lib, pkgs, ... }:

{
  imports = [
    (import ../modules/tui-common.nix)
  ];

  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
}
