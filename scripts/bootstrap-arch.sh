#!/bin/bash

pkgs=(
    archlinux-keyring

    docker
    docker-compose

    # NOTE Just for thinkpad x1carbon
    fwupd
    sof-firmware
)

aurpkgs=(
    keyd # setup keyd
    dropbox # NOTE nix's dropbox has build error
)

setup-docker() {
    sudo usermod --append --groups docker $USER
    systemctl start docker
    systemctl enable docker
}

setup-keyd() {
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

setup-nix() {
    cd ~/.setup
    nix build --extra-experimental-features 'nix-command flakes' .#homeConfigurations.pacman.activationPackage
    ./result/activate
    cd
}

setup() {
    if ! command -v yay >/dev/null 2>&1; then
	    cd $HOME
	    git clone -q --depth 1 https://aur.archlinux.org/yay-bin.git $HOME/p/yay-bin
	    cd $HOME/p/yay-bin
	    yes | makepkg -si
	    cd $HOME
	    rm -rf $HOME/p/yay-bin
    fi

    if ! command -v nix >/dev/null 2>&1; then
        sh <(curl -L https://nixos.org/nix/install) --daemon
    fi


    yay -S --sudoloop ${pkgs[@]}
    yay -S --sudoloop ${aurpkgs[@]}


    setup-docker
    setup-keyd
}

setup
