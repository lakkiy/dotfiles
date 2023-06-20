{ config, pkgs, ... }:

{
  imports = [
    (import ../modules/home/tui.nix)
    (import ../modules/home/programming.nix)
  ];

  home = {
    packages = with pkgs; [
      home-manager
      coreutils
    ];
    stateVersion = "23.05";
  };

  home.file.".config/karabiner/karabiner.json".source = ../modules/files/karabiner.json;
}
