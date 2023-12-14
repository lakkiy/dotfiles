#!/bin/bash

pkgs=(
    archlinux-keyring

    # GUI APPS
    firefox
    discord
    qbittorrent
    mpv
    #intel-gpu-tools # Monitoring

    fcitx5-im
    fcitx5-rime
    rime-double-pinyin

    ## for compile emacs
    librime
    libgccjit
    # tree-sitter

    # TUI
    docker
    docker-compose
    podman

    # NOTE Just for thinkpad x1carbon
    fwupd
    sof-firmware
)

aurpkgs=(
    # GUI
    crow-translate
    dropbox
    plex-media-player
    timeshift-bin
    ventoy-bin
    fcitx5-breeze
    goldendict-ng-git

    # TUI
    keyd
    butane-bin # generate fedora core os config
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

setup-zsh() {
    # for kde, change default shell in Konsole
    echo "
/home/${USER}/.nix-profile/bin/zsh
" | sudo tee -a /etc/shells
    chsh -s $(whereis zsh)
}

setup() {
    if [ ! -d "$HOME/p" ]; then
        mkdir $HOME/p
    fi

    if ! command -v yay >/dev/null 2>&1; then
	    cd $HOME
	    git clone -q --depth 1 https://aur.archlinux.org/yay-bin.git $HOME/tmp/yay-bin
	    cd $HOME/tmp/yay-bin
	    yes | makepkg -si
	    cd $HOME
    fi

    if [ ! -d "$HOME/p/emacs" ]; then
        git clone https://github.com/emacs-mirror/emacs.git $HOME/p/ --depth 1
    fi

    if [ ! -d "$HOME/.config/emacs" ]; then
        git clone https://github.com/404cn/eatemacs.git $HOME/.config/emacs
    fi

    if [ ! -d "$HOME/.local/share/fcitx5/rime" ]; then
        git clone https://github.com/404cn/rime.git $HOME/.local/share/fcitx5/rime
        cp -r $HOME/.local/share/fcitx5/rime $HOME/.config/emacs/
        rm -rf $HOME/.config/emacs/rime/.git
        cd
    fi

    yay -S --sudoloop ${pkgs[@]}
    yay -S --sudoloop ${aurpkgs[@]}

    systemctl enable bluetooth
    systemctl start bluetooth

    setup-docker
    setup-keyd
    setup-zsh
}

setup
