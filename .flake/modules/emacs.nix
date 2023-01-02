{ config, pkgs, emacs-overlay, ... }:

{
  services.emacs = {
    enable = true;
    package = emacs-overlay.emacsPgtk;
  };
#  programs.emacs.enable = true;
}
