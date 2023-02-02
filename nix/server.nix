{ config, pkgs, inputs, ... }:

{
  imports = [
    (import ../modules/emacs.nix)
    (import ../modules/programming.nix)
    (import ../modules/terminal.nix)
    (import ../modules/zsh.nix)
    (import ../modules/git.nix)
    (import ../modules/syncthing.nix)
  ];

  programs.ssh.enable = true;
}
