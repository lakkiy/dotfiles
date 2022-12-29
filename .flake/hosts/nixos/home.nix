{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "swim";
  home.homeDirectory = "/home/swim";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-rime ];
  };

  services.emacs.package = pkgs.emacsPgtk;
  nixpkgs.overlays = [
    (import (builtins.fetchGit {
      url = "https://github.com/nix-community/emacs-overlay.git";
      ref = "master";
      # https://hydra.nix-community.org/job/emacs-overlay/stable/emacsPgtk
      rev = "9b2084bd40761de6be748981275bcfd35444c820";
    }))
  ];

  services.syncthing.enable = true;
  services.dropbox.enable = true;

  programs = {
    fzf = {
      enable = true;
      # defaultCommand = "fd --type f --hidden --follow --exclude .git || git ls-tree -r --name-only HEAD || rg --files --hidden --follow --glob '!.git' || find .";
      # # defaultOptions = "";
      # # fileWidgetCommand = "";
      # fileWidgetOptions = [ "--preview '(bat --style=plain --color=always {} || cat {} || tree -NC {}) 2> /dev/null | head -200'" ];
      # historyWidgetOptions = [
      #   "--preview 'echo {}'"
      #   "--preview-window down:3:hidden:wrap"
      #   "--bind '?:toggle-preview'"
      #   "--exact"
      # ];
      # changeDirWidgetOptions = [ "--preview 'tree -NC {} | head -200'" ];
    };
    tealdeer = {
      enable = true;
      settings = {
        updates = {
          auto_update = true;
        };
      };
    };
    go.enable = true;
    pandoc.enable = true;

    mpv.enable = true;
    sioyek.enable = true;
  };

  home.packages = with pkgs; [
    # firefox
    # git
    zsh
    keyd
    gcc
    gdb
    gnumake
    # Proxy
    v2ray
    v2ray-geoip
    v2ray-domain-list-community
    clash
    # Tools
    neofetch
    tree
    cloc
    delta
    fzf
    fd
    ripgrep
    jq
    zoxide
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
    # DEV
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
    # Emacs tool deps
    tdlib  # telega
    xapian # xeft
    notmuch # mail
    afew # tag mail
    isync # sync mail
    cmake # compile vterm
    libtool
    librime # emacs-rime
    sdcv # dict
    imagemagick # dirvish
    mediainfo
    ffmpegthumbnailer
    poppler
    aspell # spell check


    # GUI
    emacsPgtk
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
