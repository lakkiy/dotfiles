{ config, pkgs, inputs, ... }:

{
  services.emacs.enable = true;
  programs.emacs = {
    enable = true;
    package = pkgs.emacsGit;
  };

  home.packages = with pkgs; [
    # tdlib # use docker
    librime
  ];
}
