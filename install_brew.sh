#!/bin/bash

# Cask applications
apps=(
    emacs                        # soul of the computer
    
    via # your keyboard's best friend
    hiddenbar # manage menu bar
    balenaetcher # flash iso
    raycast # ala fro spotlight, support open app via shortcut
    squirrel # cn type in
    wireshark
    telegram-desktop
    google-chrome
    firefox
    dropbox # sync file
    # avibrazil-rdm              # Retina display management
    # cheatsheet
    # clipy                      # Clipboard
    # maczip                     # Compress & extract
    # fliqlo                     # Screen Saver
    # paper                      # Wallpaper
    # hyperswitch                # alt-tab
    # iterm2                     # Terminal
    # keepingyouawake
    # keycastr                   # Show keys on the screen
    # licecap                    # Recording screen as gif
    # mounty                     # Mounty for NTFS read/write
    # mos                        # Smooth and reverse scroll
    #clashx-pro                 # Proxy: v2rayx, shadowsocksx-ng-r
	v2rayx
    # rectangle                  # Window management
    # vanilla                    # Hide menu bar icons. Alternative: bartender

    iina                       # Media player
    # microsoft-edge             # Browser: google-chrome
    karabiner-elements         # karabiner: Keboard remapping
    # hammersppon                # Ultimate tools
    # netspot                    # Wifi signal analysis and scanner
    # osxfuse                    # File system
    # veracrypt                  # File crypt
    # vox                        # Music player
    # squirrel                   # sogouinput
    # handbrake                  # transcoder

    # Audio
    # soundflower
    # soundflowerbed

    # Development
    # java                       # optional
    # docker                     # optional
    # fork                       # Git Client: gitkraken, sourcetree
    # typora                     # Markdown editor
    # visual-studio-code

    # Utilities
    # aliwangwang
    baidunetdisk
    # motrix                     # Downloader: ariang
    # macgesture
    qq
    wechat
    lark
    thunder
    # tencent-lemon

    # neteasemusic
    # youdaodict
    # youdaonote

    # zy-player
)

# command line apps
formulae_apps=(
    mongocli # mongodb command line tool
    golangci-lint # best lint for go
    mosh # ssh on udp
    tdlib # use telega in emacs
    neovim
    jupyterlab
    go
    tmux
    universal-ctags # completion, jump and find def
    aria2 # download
    cloc # count program line
    mycli # better mysql command line tool
    coreutils # gnu utils
    htop # better top
    hunspell # for emacs spell check
    ipython
    notmuch # read mail in emacs
    isync # sync mail to localhost, aka mbsync
    pandoc # convert to pdf
    tree # view file tree
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

function check {
    # Check OS
    if [[ $OSTYPE != darwin* ]]; then
        echo "${RED}Error: only install software via brew_cask on macOS.${NORMAL}" >&2
        exit 1
    fi

    # Check brew
    if ! command -v brew >/dev/null 2>&1; then
        printf "${BLUE} ➜  Installing Homebrew and Cask...${NORMAL}\n"

        xcode-select --install
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

        brew tap homebrew/cask
        brew tap homebrew/cask-fonts
        brew tap homebrew/cask-versions
        brew tap buo/cask-upgrade
    fi
}

function install () {
    for app in ${apps[@]}; do
        printf "${BLUE} ➜  Installing ${app}...${NORMAL}\n"
        brew install ${app} --cask
    done
    for app in ${formulae_apps[@]}; do
        printf "${BLUE} ➜  Installing ${app}...${NORMAL}\n"
        brew install ${app}
    done
}

function cleanup {
    brew cleanup
}

function main {
    check
    install
    cleanup
}

main
