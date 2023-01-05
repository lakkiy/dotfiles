{ config, pkgs, inputs, ... }:

{
  imports = [
    (import ../modules/programming.nix)
    (import ../modules/terminal.nix)
    (import ../modules/zsh.nix)
    (import ../modules/syncthing.nix)
    # (import ../modules/emacs.nix);
  ];

  programs = {
    ssh.enable = true;
  };
}
