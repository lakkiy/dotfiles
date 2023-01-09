{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    firefox-bin
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

  home.sessionVariables.XDG_DATA_DIRS = "$HOME/.nix-profile/share:$XDG_DATA_DIRS";
}
