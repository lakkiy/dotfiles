# General home-manager config
{ config, lib, pkgs, ... }:

{
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;
}
