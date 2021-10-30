#!/bin/bash

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

# Dotfiles
printf "${GREEN}▓▒░ Installing Dotfiles...${NORMAL}\n"
sync_repo 404cn/dotfiles $DOTFILES

# Use fish as default shell since zinit repo has deleted
ln -sf $DOTFILES/.config/fish/config.fish $HOME/.config/fish/config.fish
ln -sf $DOTFILES/.config/fish/fish_plugins $HOME/.config/fish/fish_plugins
ln -sf $DOTFILES/.config/fish/fish_plugins/functions/fisher.fish $HOME/.config/fish/fish_plugins/functions/fisher.fish
ln -sf $DOTFILES/.config/fish/fish_plugins/functions/fish_prompt.fish $HOME/.config/fish/fish_plugins/functions/fish_prompt.fish
ln -sf $DOTFILES/.config/fish/fish_plugins/completions/fisher.fish $HOME/.config/fish/fish_plugins/completions/fisher.fish

ln -sf $DOTFILES/.vimrc $HOME/.vimrc
ln -sf $DOTFILES/.tmux.conf $HOME/.tmux.conf
ln -sf $DOTFILES/.tmux.conf.osx $HOME/.tmux.conf.osx
ln -sf $DOTFILES/.globalrc $HOME/.globalrc

ln -sf $DOTFILES/.gitignore_global $HOME/.gitignore_global
ln -sf $DOTFILES/.gitconfig_global $HOME/.gitconfig_global
if is_mac; then
    cp -n $DOTFILES/.gitconfig_macOS $HOME/.gitconfig
    ln -sf $DOTFILES/config/karabiner $Home/.config/
    ln -sf $DOTFILES/.yabairc $Home/.yabairc
    ln -sf $DOTFILES/.skhdrc $Home/.skhdrc
else
    cp -n $DOTFILES/.gitconfig_linux $HOME/.gitconfig
    ln -sf $DOTFILES/.Xmodmap ~/.Xmodmap
    ln -sf $DOTFILES/.xprofile ~/.xprofile
    ln -sf $DOTFILES/config/polybar ~/.config/
    ln -sf $DOTFILES/config/dunst ~/.config/
    ln -sf $DOTFILES/config/rofi ~/.config/
    ln -sf $DOTFILES/config/sway ~/.config/

    rm -rf ~/.config/i3
    ln -sf $DOTFILES/config/i3 ~/.config/
fi
ln -sf $DOTFILES/config/kitty $HOME/.config/

# Emacs Configs
printf "${GREEN}▓▒░ Installing Emacs...${NORMAL}\n"
sync_repo 404cn/eatemacs $HOME/.config/emacs

# Entering zsh
printf "Done but you have to change default shell to shell yourself. Enjoy!\n"
