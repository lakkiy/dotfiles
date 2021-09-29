#!/bin/bash

# Install arch via archinstall and choose i3-gaps.
# Add additional packages like git vim zsh.
# Use networkmanager and set timezone to Asia/Shanghai

# install yay
if ! command -v yay >/dev/null 2>&1; then
    cd
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si
    cd
    rm -rf yay-bin
fi

pacmans=(
    cpio # unpack tar archive, install procs in zsh
    man-db
    zsh
    kitty
    hugo
    aspell
    sdcv
    graphviz
    mosh
    tdlib
    jupyterlab
    go
    tmux
    universal-ctags
    aria2
    cloc
    htop
    hunspell                   # for emacs spell check
    ipython
    notmuch                    # read mail in emacs
    isync                      # sync mail to localhost, aka mbsync
    pandoc                     # convert to pdf
    tree                       # view file tree
    mpv                        # play netease cloud music in emacs
    socat                      # with mpv
    tealdeer                   # rust version tldr
    docker
    firefox
    fcitx5
    librime
    fcitx5-rime
    fcitx5-gtk
    neofetch
    zathura # pdf reader
    flameshot # screenshot
    feh # set wallpaper
    rofi # application launcher
    ranger # file manager
    thunar
    network-manager-apple # networkmanager tray
    lxappearance # theme switcher, also change icons, fonts
    picom
    bitwarden
    dunst # notification-daemons
    gimp
    file-roller # zip and unzip file

    # TODO try to use
    gucharmap # display symbols in font
    gpick # color picker
    pulseaudio # voice control
    pamixer # command line voice control
    xorg-xbacklight # brightness control, also dep of polybar
    light # brightness command line control
    redshift # adjusts the color temperature of your screen according to your surroundings
    viewnior # picture viewer
    mpd # play music
    ncmpcpp
    mcomix # comic books
    qt5ct # change qt programs theme and icons

    # Fonts
    powerline-fonts
    wqy-bitmapfont
    wqy-microhei
    wqy-microhei-lite
    wqy-zenhei
)

yays=(
    polybar # i3 status bar replace
    wps-office
    betterlockscreen

    # Fonts
    ttf-wps-fonts
    ttf-monaco
    ttf-recursive # default font for emacs && code
    ttf-google-fonts-git # some best fonts from goole, include cardo for emacs variable pitch mode
    apple-fonts # sf-pro sf-mono etc...

    # TODO try to use
    libinput-gestures # touchpad, must add user to input group
      # sudo gpasswd -a $USER input

    emacs-git
)

for app in ${pacmans[@]}; do
    printf "${BLUE} ➜  Installing ${app}...${NORMAL}\n"
    sudo pacman -S --noconfirm ${app}
done
for app in ${yays[@]}; do
    printf "${BLUE} ➜  Installing ${app}...${NORMAL}\n"
    yay -S --noconfirm ${app}
done
