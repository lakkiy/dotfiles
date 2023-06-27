{ lib, config, pkgs, inputs, ... }:

{
  imports = [
    (import ../modules/programs/emacs.nix { inherit lib pkgs; package = pkgs.emacs-git-nox; })
    (import ../modules/programming.nix)
    (import ../modules/tui.nix)
    (import ../modules/services/syncthing.nix)
  ];

  programs.ssh.enable = true;
}
