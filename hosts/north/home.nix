{ lib, config, pkgs, inputs, ... }:

{
  imports = [
    (import ../../modules/programming.nix)
    (import ../../modules/fonts.nix)
    (import ../../modules/programs/emacs.nix { inherit lib pkgs; package = pkgs.emacs29-pgtk; })

  ];

  home.username = "gray";
  home.homeDirectory = "/home/gray";

  home.file.".config/fcitx5/config".source = ../../modules/files/fcitx5/config;
  home.file.".config/fcitx5/profile".source = ../../modules/files/fcitx5/profile;
  home.file.".config/fcitx5/conf/classicui.conf".source = ../../modules/files/fcitx5/conf/classicui.conf;
  home.file.".config/fcitx5/conf/notifications.conf".source = ../../modules/files/fcitx5/conf/notifications.conf;

  home.packages = with pkgs; [
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
