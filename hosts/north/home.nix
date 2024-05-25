{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../home-manager/shell
    ../../home-manager/syncthing
    ../../home-manager/browser
    ../../home-manager/editor
    ../../home-manager/font
    ../../home-manager/develop
  ];
  home.file."Pictures/wallpapers".source = ../files/wallpapers;
}
