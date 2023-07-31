{ lib, pkgs, package ? pkgs.emacs29-pgtk, ... }:

{
  services.emacs.enable = true;

  programs.emacs = {
    enable = true;
    package = package;
  };

  home.packages = with pkgs.emacsPackages; [
    rime
    xeft
    telega
  ];
}
