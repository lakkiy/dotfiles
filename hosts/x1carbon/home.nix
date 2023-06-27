{ lib, config, pkgs, inputs, ... }:

{
  imports = [
    (import ../../modules/programming.nix)
    (import ../../modules/desktop.nix)
    (import ../../modules/programs/emacs.nix { inherit lib pkgs; package = pkgs.emacs-pgtk; })

  ];

  home.username = "gray";
  home.homeDirectory = "/home/gray";

  # home.file.".config/fcitx5".source = ../../modules/files/fcitx5;

  home.packages = with pkgs; [
    #keyd xremap

    # use with gtk
    # https://github.com/nix-community/home-manager/issues/3113#issuecomment-1194271028
    dconf
  ];

  gtk = {
    enable = true;
    theme = {
      package = pkgs.gnome.gnome-themes-extra;
      name = "Adwaita-dark";
    };
  };
}
