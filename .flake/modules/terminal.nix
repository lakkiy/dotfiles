{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    git
    gcc
    gdb
    gnumake
    neofetch
    tealdeer
    tree
    cloc
    jq
    docker
    mycli
    litecli
    kubectl
    mosh

    # Extract
    unrar
    unzip
    p7zip
    cpio
  ];
}
