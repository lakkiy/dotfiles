{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    bottom
    cloc
    gcc
    gdb
    git
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

    # Extract
    cpio
    p7zip
    unrar
    unzip
  ];
}
