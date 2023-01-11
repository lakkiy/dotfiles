{ config, pkgs, ... }:

{
  imports = [
    (import ../modules/git.nix)
    (import ../modules/programming.nix)
    (import ../modules/terminal.nix)
    (import ../modules/zsh.nix)
  ];

  home = {
    packages = [ pkgs.home-manager ];
    stateVersion = "22.11";
  };
}
