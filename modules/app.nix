{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    crow-translate
    discord
    drawio
    firefox-bin
    plex-media-player
    sioyek
    spotify
    timeshift
    transmission-gtk
    ventoy-bin

    # TODO
    mpv
    youtube-dl
  ];
}
