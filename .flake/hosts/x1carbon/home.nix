{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "swim";
  home.homeDirectory = "/home/swim";

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-rime ];
  };

  # services.syncthing.enable = true;
  # services.dropbox.enable = true;

  programs = {

  };

  home.packages = with pkgs; [
    firefox
    git

    zsh

    keyd

    # Terminal
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
    pandoc
    mpv

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
    socat
    youtube-dl
    kubectl
    mosh

    # Programming
    python39Packages.epc
    python39Packages.orjson
    nodePackages.pyright
    python3Minimal

    go

    universal-ctags
    global
    cscope

    deno

    clojure
    leiningen

    nodePackages.typescript
    nodePackages.vscode-langservers-extracted
    nodePackages.pnpm

    # Emacs
    tdlib  # telega
    xapian # xeft
    notmuch # mail
    afew # tag mail
    isync # sync mail
    librime # emacs-rime
    imagemagick # dirvish
    mediainfo
    ffmpegthumbnailer
    poppler
    aspell # spell check


    # GUI
    sioyek
    discord
    transmission-gtk
    spotify
    crow-translate
    drawio
    ventoy-bin
    plex-media-player
    tdesktop # telegram desktop
    timeshift
    virt-manager


    # Fonts
    lxgw-wenkai
    jetbrains-mono
    symbola
    sarasa-gothic
    source-han-serif
    roboto-mono
    ibm-plex
    noto-fonts
    noto-fonts-extra
    noto-fonts-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    cardo
    #miss: monego wps-fonts bookerly latin-modern-mono


    # For gnome
    gnome.gnome-tweaks
    gnomeExtensions.blur-my-shell
    gnomeExtensions.appindicator
    pop-gtk-theme
    pop-icon-theme
    gnomeExtensions.gsconnect
    gnomeExtensions.caffeine
    gnomeExtensions.pop-shell

  ];
}
