{ lib, config, pkgs, inputs, ... }:

{
  imports = [
    (import ../modules/home/emacs.nix)
    (import ../modules/programming.nix)
    (import ../modules/tui.nix)
    (import ../modules/home/syncthing.nix)
  ];

  programs.ssh.enable = true;
}
