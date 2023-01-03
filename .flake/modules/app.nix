{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    firefox
    sioyek
    discord
    transmission-gtk
    spotify
    crow-translate
    drawio
    ventoy-bin
    plex-media-player
    tdesktop # telegram desktop
    timeshift
    virt-manager
  ];
}
