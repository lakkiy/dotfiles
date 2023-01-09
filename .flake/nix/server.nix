{ config, pkgs, inputs, ... }:

{
  imports = [
    (import ../modules/programming.nix)
    (import ../modules/terminal.nix)
    (import ../modules/zsh.nix)
    (import ../modules/git.nix)
    (import ../modules/syncthing.nix)
  ];

  programs = {
    ssh.enable = true;
    emacs = {
      enable = true;
      package = inputs.emacs-overlay.packages.x86_64-linux.emacsGit-nox;
    };
  };
}
