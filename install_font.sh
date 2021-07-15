#!/bin/bash

# Get OS name
SYSTEM=`uname -s`

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

YES=0
NO=1
promote_yn() {
    eval ${2}=$NO
    read -p "$1 [y/N]: " yn
    case $yn in
        [Yy]* )    eval ${2}=$YES;;
        [Nn]*|'' ) eval ${2}=$NO;;
        *)         eval ${2}=$NO;;
    esac
}

# Sync repository
sync_repo() {
    local repo_uri="$1"
    local repo_path="$2"
    local repo_branch="$3"

    if [ -z "$repo_branch" ]; then
        repo_branch="main"
    fi

    if [ ! -e "$repo_path" ]; then
        mkdir -p "$repo_path"
        git clone --depth 1 --branch $repo_branch "https://github.com/$repo_uri.git" "$repo_path"
    else
        cd "$repo_path" && git pull --rebase --stat origin $repo_branch; cd - >/dev/null
    fi
}


function check {
    if ! command -v git >/dev/null 2>&1; then
        echo "${RED}Error: git is not installed${NORMAL}" >&2
        exit 1
    fi
}

function install {
    printf "${BLUE} ➜  Installing fonts...${NORMAL}\n"

    if [ "$SYSTEM" = "Darwin" ]; then
        # macOS
        font_dir="$HOME/Library/Fonts"

        fonts=(
            # font-source-code-pro
            # font-dejavu-sans
            # font-inconsolata
            # font-hack-nerd-font

            # font-symbola
            font-hanamina
            font-sarasa-gothic
            font-gnu-unifont
            # font-wenquanyi-micro-hei
            # font-wenquanyi-micro-hei-lite
            # font-wenquanyi-zen-hei
        )

        for f in ${fonts[@]}; do
            brew install ${f} --cask
        done
        brew cleanup
    elif [ "$SYSTEM" = "Linux" ]; then
        # Linux
        font_dir="$HOME/.local/share/fonts"
        mkdir -p $font_dir

        # TODO after install font
        fonts=(
            # fonts-hack-ttf
            # fonts-powerline
            fonts-wqy-microhei
            # fonts-wqy-zenhei
            # ttf-mscorefonts-installer
        )

        # TODO no confirm
        for f in ${fonts[@]}; do
            sudo yay -S ${f}
        done

        fc-cache -f $font_dir

        # Nerd font
        # sh -c "$(curl -fsSL https://github.com/ryanoasis/nerd-fonts/raw/master/install.sh) Hack"
    fi
}

function main {
    check
    install
}

main
