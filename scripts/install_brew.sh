#!/bin/bash

# Cask applications
apps=(
    clashx-pro         # Proxy: v2rayx
    netnewswire
    nrlquaker-winbox   # manage route os
    discord
    via                # your keyboard's best friend
    vagrant-vmware-utility
    vmware-fusion
    docker
    licecap            # Recording screen as gif
    baidunetdisk
    thunder
    iina               # Media player
    hiddenbar          # manage menu bar
    karabiner-elements # karabiner: Keboard remapping
    squirrel           # input method
    raycast            # ala fro spotlight, support open app via shortcut
    firefox
    dropbox            # sync file
    kitty              # terminal
    keepingyouawake
    mounty             # Mounty for NTFS read/write
    neteasemusic
    maczip             # Compress & extract
    whichspace         # with yabai, show space number on menu bar
    balenaetcher       # flash iso
    mos                # Smooth and reverse scroll

    # ----------Fonts----------
    font-cardo # form nasy-theme variable pitch font
    font-hanamina
    font-sarasa-gothic
    font-gnu-unifont
)

# command line apps
formulae_apps=(
    global # gnu global gtags
      # pip3 install pygments for more languages support like go/rust
    koekeishiya/formulae/skhd  # use with yabai
    koekeishiya/formulae/yabai # window manager
      # defaults write com.apple.finder DisableAllAnimations -bool true
      # killall Finder # or logout and login
    basictex                   # export org to pdf
      # tlmgr update --self
      # tlmgr install wrapfig marvosym wasy wasysym capt-of
    aspell
    hugo                       # blog that support org mode
    sdcv                       # stardict console version
    graphviz                   # for org-roam
    pngpaste                   # for org-download-clipboard
    kubectl                    # source <(kubectl completion zsh) to enable shell auto complete
    miniconda                  # python virtual env
    pgcli                      # postgress command line tool
    litecli                    # sqllite command line tool
    mongocli                   # mongodb command line tool
    golangci-lint              # best lint for go
    mosh                       # ssh on udp
    tdlib                      # use telega in emacs
    jupyterlab
    go
    tmux
    universal-ctags            # completion, jump and find def
    aria2                      # download
    cloc                       # count program line
    mycli                      # better mysql command line tool
    coreutils                  # gnu utils
    htop                       # better top
    hunspell                   # for emacs spell check
    ipython
    notmuch                    # read mail in emacs
    isync                      # sync mail to localhost, aka mbsync
    pandoc                     # convert to pdf
    tree                       # view file tree
    mpv                        # play netease cloud music in emacs
    socat                      # with mpv
    tealdeer                   # rust version tldr
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
        brew tap buo/cask-upgrade
        brew tap d12frosted/emacs-plus

        brew install emacs-plus@28 --with-no-titlebar
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
