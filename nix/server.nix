{ config, pkgs, inputs, ... }:

{
  imports = [
    (import ../modules/home/programs/emacs.nix)
    (import ../modules/home/programming.nix)
    (import ../modules/home/tui.nix)
    (import ../modules/home/services/syncthing.nix)
  ];

  programs.ssh.enable = true;
}
