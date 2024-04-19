{
  lib,
  pkgs,
  ...
}: let
  # https://nixos.wiki/wiki/TexLive
  tex = pkgs.texlive.combine {
    inherit
      (pkgs.texlive)
      scheme-small dvisvgm
      dvipng # for preview and export as html
      wrapfig amsmath ulem hyperref capt-of
      #(setq org-latex-compiler "xelatex")
      #(setq org-preview-latex-default-process 'dvisvgm)
      digestif # lsp server
      ctex
      ;
  };
in {
  services.emacs.enable = true;

  home.packages = with pkgs; [
    emacsPackages.telega

    tex # basic support for org mode
    tikzit # draw
    ltex-ls # lsp server
    w3m # read html mail in emacs
    readability-cli # firefox reader mode, for emacs eww
    typst typstfmt typst-lsp typst-live
    aspell aspellDicts.en aspellDicts.en-computers
    translate-shell
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
    extraPackages = epkgs:
      with epkgs; [
        # install all treesitter grammars
        (treesit-grammars.with-grammars (p: builtins.attrValues p))

        # emacs-rime
        (epkgs.melpaPackages.rime.overrideAttrs (old: {
          recipe = pkgs.writeText "recipe" ''
            (rime :repo "DogLooksGood/emacs-rime"
                  :files (:defaults "lib.c" "Makefile" "librime-emacs.so")
                  :fetcher github)
          '';
          postPatch =
            old.postPatch
            or ""
            + ''
              emacs --batch -Q -L . \
                  --eval "(progn (require 'rime) (rime-compile-module))"
            '';
          buildInputs = old.buildInputs ++ (with pkgs; [librime]);
        }))
      ];
  };

  home.activation.checkEmacsDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ ! -d $HOME/.emacs.d ]; then
       git clone https://github.com/mrunhap/.emacs.d $HOME/.emacs.d
    fi
    if [ ! -d $HOME/.emacs.d/rime ]; then
       git clone https://github.com/mrunhap/rime $HOME/.emacs.d/rime
    fi
  '';
}
