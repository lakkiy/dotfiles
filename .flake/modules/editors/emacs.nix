{ config, pkgs, ... }:

{
  services.emacs.enable = true;
  services.emacs.package = pkgs.emacsPgtk;
  nixpkgs.overlays = [
    (import (builtins.fetchGit {
      url = "https://github.com/nix-community/emacs-overlay.git";
      ref = "master";
      # https://hydra.nix-community.org/job/emacs-overlay/stable/emacsPgtk
      rev = "9b2084bd40761de6be748981275bcfd35444c820";
    }))
  ];
}
