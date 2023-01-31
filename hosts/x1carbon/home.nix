{ config, pkgs, inputs, ... }:

{
  imports = [
    (import ../../modules/app.nix)
    (import ../../modules/syncthing.nix)
    (import ../../modules/fonts.nix)
  ];

  home.username = "swim";
  home.homeDirectory = "/home/swim";

  home.packages = with pkgs; [
    # TODO
    keyd
  ];
}
