{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    cloc
    docker
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
