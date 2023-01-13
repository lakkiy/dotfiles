{ config, pkgs, inputs, ... }:

{
  services.emacs.enable = true;

  programs.emacs = {
    enable = true;
    package = pkgs.emacsPgtk;
  };

  home.packages = with pkgs; [
    emacs-all-the-icons-fonts
  ];
}
