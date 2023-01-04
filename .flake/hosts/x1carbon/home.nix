{ config, pkgs, inputs, ... }:

{
  imports = [
    (import ../../modules/app.nix)
#    (import ../../modules/dropbox.nix)
    (import ../../modules/syncthing.nix)
    (import ../../modules/video.nix)
    (import ../../modules/fonts.nix)
    (import ../../modules/gnome.nix)
    (import ../../modules/fcitx5.nix)
  ];

  home.username = "swim";
  home.homeDirectory = "/home/swim";

  home.packages = with pkgs; [
    # TODO
    keyd
  ];
}
