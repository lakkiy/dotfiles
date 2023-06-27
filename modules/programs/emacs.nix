{ lib, pkgs, package ? pkgs.emacs-pgtk, ... }:

{
  services.emacs.enable = true;

  programs.emacs = {
    enable = true;
    package = package;
  };

  home.packages = with pkgs.emacsPackages; [
    rime
    xeft
    telega
  ];

  home.activation.checkEmacsDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    CONFIG="$HOME/.config/emacs"

    if [ ! -d "$CONFIG" ]; then
      git clone https://github.com/404cn/eatemacs.git $CONFIG
      emacs --batch --eval "(require 'org)" --eval '(org-babel-tangle-file "~/.config/emacs/config.org")'
    fi
  '';
}
