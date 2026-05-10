#!/usr/bin/env zsh
# hosts/homelab.sh — Home server (Arch Linux, x86_64)

PACKAGES=(
    # System
    base-devel
    wget
    git
    git-lfs
    cifs-utils      # CIFS/SMB mounts

    # Services
    transmission-cli
    vsftpd
)

AUR_PACKAGES=()

SERVICES=(
    transmission:enable
    vsftpd:enable
)

DOTFILES=(
    .zshrc
    .gitconfig
)
