#!/bin/sh

# insert 199.232.68.133 raw.githubusercontent.com to host if could not reslove raw.githubusercontent.com

# Variables
DOTFILES=$HOME/.dotfiles

# Get OS informatio
OS=`uname -s`

# Only enable exit-on-error after the non-critical colorization stuff,
# which may fail on systems lacking tput or terminfo
# set -e

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

# Check git
command -v git >/dev/null 2>&1 || {
    echo "${RED}Error: git is not installed${NORMAL}" >&2
    exit 1
}

# Check curl
command -v curl >/dev/null 2>&1 || {
    echo "${RED}Error: curl is not installed${NORMAL}" >&2
    exit 1
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

is_mac()
{
    [ "$OS" = "Darwin" ]
}

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

# Zsh plugin manager
printf "${GREEN}▓▒░ Installing Zinit...${NORMAL}\n"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

# Dotfiles
printf "${GREEN}▓▒░ Installing Dotfiles...${NORMAL}\n"
sync_repo 404cn/dotfiles $DOTFILES

ln -sf $DOTFILES/.zshenv $HOME/.zshenv
ln -sf $DOTFILES/.zshrc $HOME/.zshrc
ln -sf $DOTFILES/.vimrc $HOME/.vimrc
ln -sf $DOTFILES/.tmux.conf $HOME/.tmux.conf
ln -sf $DOTFILES/.tmux.conf.osx $HOME/.tmux.conf.osx
ln -sf $DOTFILES/.globalrc $HOME/.globalrc

ln -sf $DOTFILES/.gitignore_global $HOME/.gitignore_global
ln -sf $DOTFILES/.gitconfig_global $HOME/.gitconfig_global
if is_mac; then
    cp -n $DOTFILES/.gitconfig_macOS $HOME/.gitconfig
    ln -sf $DOTFILES/config/karabiner $Home/.config/karabiner
    ln -sf $DOTFILES/.yabairc $Home/.yabairc
    ln -sf $DOTFILES/.skhdrc $Home/.skhdrc
else
    cp -n $DOTFILES/.gitconfig_linux $HOME/.gitconfig
    ln -sf $DOTFILES/.Xmodmap $Home/.Xmodmap
    ln -sf $DOTFILES/.xprofile $Home/.xprofile
    ln -sf $DOTFILES/config/polybar $Home/.config/polybar
    ln -sf $DOTFILES/config/dunst $Home/.config/dunst
    ln -sf $DOTFILES/config/rofi $Home/.config/rofi
    ln -sf $DOTFILES/config/i3 $Home/.config/i3
    ln -sf $DOTFILES/config/sway $Home/.config/sway
fi
ln -sf $DOTFILES/config/kitty $HOME/.config/kitty

# Emacs Configs
printf "${GREEN}▓▒░ Installing Emacs...${NORMAL}\n"
sync_repo 404cn/eatemacs $HOME/.config/emacs

# Entering zsh
printf "Done. Enjoy!\n"
if command -v zsh >/dev/null 2>&1; then
    if [ "$OSTYPE" != "cygwin" ] && [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s $(which zsh)
        printf "${GREEN} You need to logout and login to enable zsh as the default shell.${NORMAL}\n"
    fi
    env zsh
else
    echo "${RED}Error: zsh is not installed${NORMAL}" >&2
    exit 1
fi
