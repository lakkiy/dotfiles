#!/bin/bash
######################################################################
# Install packages for Archlinux that can't managed by nix(like system
# services or GUI applications).
######################################################################

pkgs=(
    archlinux-keyring
    git
    zsh
    keyd

    firefox
    emacs-wayland
    docker
    docker-compose
    # discord
    # qbittorrent
    # mpv
    # fcitx5-im
    # fcitx5-rime
    # rime-double-pinyin
    # librime
    # libgccjit
    # tree-sitter
    # NOTE Just for thinkpad x1carbon
    # fwupd
    # sof-firmware
)

aurpkgs=(
    # dropbox
    # plex-media-player
    # ventoy-bin
    # fcitx5-breeze
    # goldendict-ng-git
)

# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if command -v tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
fi

function check() {
    if ! command -v pacman >/dev/null 2>&1; then
        echo "${RED}Error: not Archlinux or its devrived edition.${NORMAL}" >&2
        exit 1
    fi
    if ! command -v nix >/dev/null 2>&1; then
        curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
    fi
    if ! command -v yay >/dev/null 2>&1; then
	    git clone -q --depth 1 https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
	    cd /tmp/yay-bin
	    yes | makepkg -si
	    cd $HOME
    fi
}

function install() {
    printf "\n${BLUE}➜ Refreshing database...${NORMAL}\n"
    sudo pacman -Syu
    printf "\n"

    for p in ${pkgs[@]}; do
        printf "\n${BLUE}➜ Installing ${p}...${NORMAL}\n"
        sudo pacman -Sc --needed --noconfirm ${p}
    done
    for p in ${aurpkgs[@]}; do
        printf "\n${BLUE}➜ Installing ${p}...${NORMAL}\n"
        yay -Sc --noconfirm --sudoloop ${p}
    done
}

function setup-docker() {
    sudo usermod --append --groups docker $USER
    systemctl enable docker
    systemctl start docker
}

function setup-keyd() {
    echo "
[ids]
*
[main]
capslock = overload(control, esc)
control = overload(control, esc)
" | sudo tee /etc/keyd/default.conf

    systemctl enable keyd
    systemctl start keyd
}

function setup-zsh() {
    # for kde, change default shell in Konsole
    echo "
/home/${USER}/.nix-profile/bin/zsh
" | sudo tee -a /etc/shells
    chsh -s $(whereis zsh)
}

function setup() {
    setup-docker
    setup-keyd
    # setup-zsh
}

function main() {
    check
    install
    setup
}

main
