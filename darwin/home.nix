{ config, pkgs, ... }:

{
  imports = [
    (import ../modules/tui.nix)
    (import ../modules/programming.nix)
  ];

  home = {
    packages = with pkgs; [
      home-manager
      coreutils
    ];
    stateVersion = "23.11";
  };

  home.file."Pictures/wallpapers".source = ../modules/files/wallpapers;
  home.file.".config/karabiner/karabiner.json".source = ../modules/files/karabiner.json;
}
