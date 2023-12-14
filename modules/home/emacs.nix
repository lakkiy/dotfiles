{ config, pkgs, ... }:

{
  services.emacs.enable = true;

  home.packages = with pkgs; [
    tdlib
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
    extraPackages = epkgs: with epkgs; [
      (treesit-grammars.with-grammars (p: builtins.attrValues p))
    ];
  };
}
