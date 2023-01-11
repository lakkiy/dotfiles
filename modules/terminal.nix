{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
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
    bottom

    # Extract
    cpio
    p7zip
    unrar
    unzip
  ];
}
