# General home-manager config
{ config, lib, pkgs, ... }:

{
  imports = [
    (import ../modules/proxy.nix)
    (import ../modules/programming.nix)
    (import ../modules/terminal.nix)
  ];

  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
}
