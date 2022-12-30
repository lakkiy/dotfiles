{ config, pkgs, ... }:

{
  home.username = "root";
  home.homeDirectory = "/root";

  programs = {
  };

  home.packages = with pkgs; [
  ];
}
