{ config, pkgs, inputs, ... }:

{
  imports = [
    (import ../../modules/home/programming.nix)
  ];

  home.username = "gray";
  home.homeDirectory = "/home/gray";

  home.packages = with pkgs; [
    #keyd xremap
  ];
}
