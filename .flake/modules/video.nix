{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    mpv
    youtube-dl
  ];
}
