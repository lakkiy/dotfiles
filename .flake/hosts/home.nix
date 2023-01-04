# General home-manager config
{ config, lib, pkgs, ... }:

{
  imports = [
    (import ../modules/proxy.nix)
    (import ../modules/programming.nix)
    (import ../modules/terminal.nix)
    (import ../modules/emacs.nix)
  ];

  home.stateVersion = "22.05";
  programs.home-manager.enable = true;
}
