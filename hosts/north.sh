#!/usr/bin/env zsh
# hosts/north.sh — NixOS → Arch Linux desktop (x86_64)

PACKAGES=(
    # System / utilities
    base-devel
    wget
    tree
    progress      # coreutils viewer (dd)
    iperf3        # network performance
    p7zip
    fastfetch
    fd
    ripgrep
    fzf
    jq
    htop
    man-db
    zoxide
    tldr          # tealdeer equivalent
    pandoc
    git
    git-lfs
    delta         # better diff

    # Shell
    zsh

    # Dev tools
    emacs
    universal-ctags
    global
    just
    make
    cloc
    go
    gopls
    delve
    rust
    cargo
    rustfmt
    clang
    lld
    nodejs
    npm
    pnpm

    # Apps
    nautilus
    mpv
    obs-studio
    localsend
    xdg-user-dirs
    filezilla
)

AUR_PACKAGES=(
    maestral           # open source dropbox client
    maestral-gui
    zotero-bin         # PDF / reference manager
    follow-bin         # RSS reader
    emacs-lsp-booster
)

SERVICES=(
    NetworkManager:enable
)

DOTFILES=(
    .zshrc
    .gitconfig
    .globalrc
)
