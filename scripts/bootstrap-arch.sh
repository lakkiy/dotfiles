#!/bin/bash

pkgs=(
    archlinux-keyring

    librime # emacs-rime
    xapian-core # emacs xeft
)

aurpkgs=(
    keyd # setup keyd
)

setup() {
    if ! command -v nix >/dev/null 2>&1; then
        sh <(curl -L https://nixos.org/nix/install) --daemon
    fi

    if ! command -v yay >/dev/null 2>&1; then
	    cd $HOME
	    git clone -q --depth 1 https://aur.archlinux.org/yay-bin.git $HOME/p/yay-bin
	    cd $HOME/p/yay-bin
	    yes | makepkg -si
	    cd $HOME
	    rm -rf $HOME/p/yay-bin
    fi

    yay -S --sudoloop ${pkgs[@]}
    yay -S --sudoloop ${aurpkgs[@]}

    sudo echo "
[ids]
*
[main]
capslock = overload(control, esc)
control = overload(control, esc)
" > /etc/keyd/default.conf
    systemctl enable keyd
    systemctl start keyd
}

setup
