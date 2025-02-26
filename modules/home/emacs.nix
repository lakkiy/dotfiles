{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.emacs;

  # https://nixos.wiki/wiki/TexLive
  tex = pkgs.texlive.combine {
    inherit
      (pkgs.texlive)
      scheme-small dvisvgm dvipng wrapfig amsmath ulem hyperref capt-of
      #(setq org-latex-compiler "xelatex")
      #(setq org-preview-latex-default-process 'dvisvgm)
      digestif # lsp server
      ctex     # Chinese support
      ;
  };
in {
  options.my.emacs = {
    enable = mkEnableOption "emacs";

    package = mkOption {
      type = types.package;
      default = pkgs.emacs30-pgtk;
      defaultText = literalExpression "pkgs.emacs30-pgtk";
      example = literalExpression "pkgs.emacs";
      description = "The Emacs package to use.";
    };
  };

  config = mkIf cfg.enable {
    services.emacs.enable = true;

    home.packages = with pkgs; [
      tex                       # basic support for org mode
      tikzit                    # draw in LaTeX
      ltex-ls                   # lsp server for grammar/spell check for org,md etc
      w3m                       # read html mail in emacs
      readability-cli           # firefox reader mode, for emacs eww
      typst typstfmt typst-live # LaTeX
      d2                        # draw
      aspell aspellDicts.en aspellDicts.en-computers
    ];

    programs.emacs = {
      enable = true;
      package = config.my.emacs.package;
      extraPackages = epkgs:
        with epkgs; [
          melpaPackages.telega
          # install all treesitter grammars
          (treesit-grammars.with-grammars (p: builtins.attrValues p))
          rime
        ];
    };
  };
}
