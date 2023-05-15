{ config, pkgs, ... }:

{
  imports = [
    (import ../modules/home/tui.nix)
    (import ../modules/home/programming.nix)
  ];

  home = {
    packages = [ pkgs.home-manager ];
    stateVersion = "22.11";
  };
}
