{ config, pkgs, ... }:

{
  imports = [
    (import ./terminal.nix)
    (import ./zsh.nix)
  ];
}
