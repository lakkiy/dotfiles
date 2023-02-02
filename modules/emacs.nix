{ config, pkgs, inputs, ... }:

{
  services.emacs.enable = true;

  programs.emacs = {
    enable = true;
    package = pkgs.emacsGit;
  };

  home.packages = with pkgs; [
    librime
    rime-data
    xapian
  ];
}
