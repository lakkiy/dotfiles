{ config, pkgs, inputs, ... }:

{
  services.emacs.enable = true;

  programs.emacs = {
    enable = true;
    package = pkgs.emacsGit;
  };

  home.packages = with pkgs.emacsPackages; [
      lsp-bridge
      rime
      xeft
      magit
  ];
}
