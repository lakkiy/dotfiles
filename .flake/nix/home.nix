{ config, pkgs, inputs, user, ... }:

{
  programs = {
    home-manager.enable = true;
  };

  home.packages = with pkgs; [
    zsh

    # Terminal
    gcc
    gdb
    gnumake
    ripgrep
    delta
    fzf
    fd
    jq
    zoxide
    neofetch
    tree
    cloc
    mosh

    # Key Remap
    keyd

    # Network Proxy
    v2ray
    v2ray-geoip
    v2ray-domain-list-community
    clash

    # Extract
    unrar
    unzip
    p7zip
    cpio

    # Misc
    docker
    mycli
    litecli
    kubectl
    youtube-dl

    # Programming
    python39Packages.epc
    python39Packages.orjson
    nodePackages.pyright
    universal-ctags
    global
    cscope
    deno
    clojure
    leiningen
    nodePackages.typescript
    nodePackages.vscode-langservers-extracted
    nodePackages.pnpm
    python3Minimal

    # Emacs
    tdlib       # telega
    xapian      # xeft
    notmuch     # mail
    afew        # tag mail
    isync       # sync mail
    libtool     # what is this for?
    librime     # emacs-rime
    aspell      # spell check
    imagemagick ## dirvish
    mediainfo
    ffmpegthumbnailer
    poppler
  ];

  nix = {                                               # Nix Package Manager settings
    settings ={
      auto-optimise-store = true;                       # Optimise syslinks
      experimental-features = [ "nix-command" "flakes" ];
    };
    package = pkgs.nixFlakes;                           # Enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
  };
  nixpkgs.config.allowUnfree = true;                    # Allow proprietary software.
}
