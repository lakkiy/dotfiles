{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    git
    zsh
    gcc
    gdb
    gnumake
    neofetch
    tealdeer
    tree
    cloc
    delta
    fzf
    fd
    ripgrep
    jq
    zoxide
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
