
#!/bin/sh

# Variables
DOTFILES=$HOME/.dotfiles
EMACSD=$HOME/.config/emacs
FZF=$HOME/.fzf
# TMUX=$HOME/.tmux
ZSH=$HOME/.zinit

# Get OS informatio
OS=`uname -s`
OSREV=`uname -r`
OSARCH=`uname -m`

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

is_linux()
{
    [ "$OS" = "Linux" ]
}

is_arch() {
    command -v yay >/dev/null 2>&1 || command -v pacman >/dev/null 2>&1
}

sync_brew_package() {
    if ! command -v brew >/dev/null 2>&1; then
        echo "${RED}Error: brew is not found${NORMAL}" >&2
        return 1
    fi

    if ! command -v ${1} >/dev/null 2>&1; then
        brew install ${1} >/dev/null
    else
        brew upgrade ${1} >/dev/null
    fi
}

sync_arch_package() {
    if command -v yay >/dev/null 2>&1; then
        yay -Ssu --noconfirm ${1} >/dev/null
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Ssu --noconfirm ${1} >/dev/null
    else
        echo "${RED}Error: pacman and yay are not found${NORMAL}" >&2
        return 1
    fi
}

# Clean all configurations
clean_dotfiles() {
    confs="
    .gitconfig
    .tmux.conf
    .vimrc
    .zshenv
    .zshrc
    .zshrc.local
    "
    for c in ${confs}; do
        [ -f $HOME/${c} ] && mv $HOME/${c} $HOME/${c}.bak
    done

    [ -d $EMACSD ] && mv $EMACSD $EMACSD.bak

    rm -rf $ZSH $TMUX $FZF

    # rm -f $HOME/.fzf.*
    rm -f $HOME/.gitignore_global $HOME/.gitconfig_global
    rm -f $HOME/.tmux.conf
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

# Reset configurations
# $TMUX $FZF
if [ -d $ZSH ] || [ -d $EMACSD ]; then
    promote_yn "Do you want to reset all configurations?" "continue"
    if [ $continue -eq $YES ]; then
        clean_dotfiles
    fi
fi

# Brew
if is_mac; then
    printf "${GREEN}▓▒░ Installing Homebrew...${NORMAL}\n"
    if ! command -v brew >/dev/null 2>&1; then
        # Install homebrew
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Tap cask and cask-upgrade
        brew tap homebrew/cask
        brew tap homebrew/cask-versions
        brew tap homebrew/cask-fonts
        brew tap buo/cask-upgrade
        brew tap railwaycat/emacsmacport
    fi
fi

# Zsh plugin manager
printf "${GREEN}▓▒░ Installing Zinit...${NORMAL}\n"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

# Dotfiles
printf "${GREEN}▓▒░ Installing Dotfiles...${NORMAL}\n"
sync_repo 404cn/dotfiles $DOTFILES

chmod +x $DOTFILES/install.sh
chmod +x $DOTFILES/install_brew.sh
chmod +x $DOTFILES/install_go.sh

ln -sf $DOTFILES/.zshenv $HOME/.zshenv
ln -sf $DOTFILES/.zshrc $HOME/.zshrc
ln -sf $DOTFILES/.vimrc $HOME/.vimrc
ln -sf $DOTFILES/.tmux.conf $HOME/.tmux.conf
ln -sf $DOTFILES/.condarc $HOME/.condarc

cp -n $DOTFILES/.zshrc.local $HOME/.zshrc.local
cp -n $DOTFILES/.zshenv.local $HOME/.zshenv.local

ln -sf $DOTFILES/.gitignore_global $HOME/.gitignore_global
ln -sf $DOTFILES/.gitconfig_global $HOME/.gitconfig_global
if is_mac; then
    cp -n $DOTFILES/.gitconfig_macOS $HOME/.gitconfig
else
    cp -n $DOTFILES/.gitconfig_linux $HOME/.gitconfig
fi

# Emacs Configs
printf "${GREEN}▓▒░ InstalliEmacs...${NORMAL}\n"
sync_repo 404cn/fooemacs $EMACSD

# Entering zsh
# TODO chsh in linux
printf "Done. Enjoy!\n"
if command -v zsh >/dev/null 2>&1; then
    env zsh
else
    echo "${RED}Error: zsh is not installed${NORMAL}" >&2
    exit 1
fi
