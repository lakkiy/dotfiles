{ pkgs, ... }:

{
  my.emacs.enable = true;
  my.emacs.package = pkgs.emacs-nox;
  my.dev.enable = true;
  my.syncthing.enable = true;
}
