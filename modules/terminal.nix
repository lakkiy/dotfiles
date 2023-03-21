{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    cloc
    gnumake
    jq
    kubectl
    litecli
    man
    mosh
    mycli
    neofetch
    tealdeer
    tree
    plantuml-c4
    hunspell
    ltex-ls

    # Extract
    cpio
    p7zip
    unrar
    unzip
  ];

  programs = {
    btop.enable = true;
  };
}
