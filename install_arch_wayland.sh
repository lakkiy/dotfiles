#!/bin/bash

# Packages
packages=(
    # ONLY FOR WAYLAND
    grim # screenshot in wayland
    slurp # screenshot in wayland

    # COMMON
    emacs-pgtk-native-comp-git
    neofetch                    # screenfetch
    thunar # file manager
    thunar-dropbox # dropbox file manager ind
    dropbox

    # Fonts
    ttf-bookerly
    wqy-bitmapfont
    powerline-fonts
    wqy-microhei
    wqy-microhei-lite
    wqy-zenhei
    bdf-unifont
    ttf-monaco
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
    if ! command -v yay >/dev/null 2>&1 && ! command -v pacman >/dev/null 2>&1; then
        echo "${RED}Error: not Archlinux or its devrived edition.${NORMAL}" >&2
        exit 1
    fi
}

function install() {
    CMD=''
    if command -v yay >/dev/null 2>&1; then
        CMD='yay -S --noconfirm'
    elif command -v pacman >/dev/null 2>&1; then
        CMD='sudo pacman -S --noconfirm'
    else
        echo "${RED}Error: not Archlinux or its devrived edition.${NORMAL}" >&2
        exit 1
    fi

    for p in ${packages[@]}; do
        printf "\n${BLUE}➜ Installing ${p}...${NORMAL}\n"
        ${CMD} ${p}
    done
}

function main() {
    check
    install
}

main
