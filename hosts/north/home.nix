{ lib, config, pkgs, inputs, ... }:

{
  imports = [
    (import ../../modules/programming.nix)
    (import ../../modules/home/fonts.nix)
    (import ../../modules/home/fcitx5.nix)
    (import ../../modules/home/emacs.nix)
    (import ../../modules/home/gtk.nix)
  ];

  home.username = "gray";
  home.homeDirectory = "/home/gray";
}
