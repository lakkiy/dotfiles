#!/bin/bash

pkgs=(
    archlinux-keyring

    # GUI APPS
    firefox
    discord
    qbittorrent
    mpv
    #intel-gpu-tools # Monitoring
    #wezterm

    fcitx5-im
    fcitx5-rime
    rime-double-pinyin

    ## for compile emacs
    librime
    libgccjit
    tree-sitter


    # TUI
    docker
    docker-compose

    # NOTE Just for thinkpad x1carbon
    fwupd
    sof-firmware
)

aurpkgs=(
    # GUI
    spotify # spotify --enable-features=UseOzonePlatform --ozone-platform=wayland
    crow-translate
    dropbox
    plex-media-player
    timeshift-bin
    ventoy-bin
    fcitx5-breeze

    # TUI
    keyd
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

setup-nix() {
    cd ~/.setup
    nix build --extra-experimental-features 'nix-command flakes' .#homeConfigurations.pacman.activationPackage
    ./result/activate
    cd
}

setup() {
    if [ ! -d "$HOME/p" ]; then
        mkdir $HOME/p
    fi

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
