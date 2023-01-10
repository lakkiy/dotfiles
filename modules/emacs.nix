{ config, pkgs, inputs, ... }:

{
  programs.emacs = {
    enable = true;
    package = inputs.emacs-overlay.packages.x86_64-linux.emacsPgtk;
  };
}
