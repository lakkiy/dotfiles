{ config, pkgs, ... }:

{
  services.emacs.enable = true;

  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
    extraPackages = epkgs: with epkgs; [
      # install all treesitter grammars
      (treesit-grammars.with-grammars (p: builtins.attrValues p))

      # emacs-rime
      (epkgs.melpaPackages.rime.overrideAttrs (old: {
        recipe = pkgs.writeText "recipe" ''
    (rime :repo "DogLooksGood/emacs-rime"
          :files (:defaults "lib.c" "Makefile" "librime-emacs.so")
          :fetcher github)
  '';
        postPatch = old.postPatch or "" + ''
    emacs --batch -Q -L . \
        --eval "(progn (require 'rime) (rime-compile-module))"
  '';
        buildInputs = old.buildInputs ++ (with pkgs; [ librime ]);
      }))

    ];
  };
}
