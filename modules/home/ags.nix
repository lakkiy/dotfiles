{ inputs, pkgs, ... }:

{
  home.file.".config/ags" = {
    source = ../files/ags;
    recursive = true;
  };

  home.packages = with pkgs; [
    libsoup_3
    ags
  ];
}
