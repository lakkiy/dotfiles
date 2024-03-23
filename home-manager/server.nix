{ lib, config, pkgs, inputs, ... }:

{
  imports = [
    (import ./emacs.nix)
    (import ./programming.nix)
    (import ./shell.nix)
    (import ./syncthing.nix)
  ];

  programs.ssh.enable = true;
}
