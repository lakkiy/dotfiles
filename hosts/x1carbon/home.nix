{ config, pkgs, inputs, ... }:

{
  imports = [
    # (import ../../modules/syncthing.nix)
  ];

  home.username = "gray";
  home.homeDirectory = "/home/gray";

  home.packages = with pkgs; [
    # TODO
    keyd
  ];
}
