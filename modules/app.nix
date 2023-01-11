{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    crow-translate
    discord
    drawio
    firefox-bin
    retroarch
    plex-media-player
    sioyek
    spotify
    tdesktop
    timeshift
    transmission-gtk
    ventoy-bin

    # TODO
    mpv
    youtube-dl
  ];
}
