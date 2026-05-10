#!/usr/bin/env zsh
# hosts/macmini.sh — Mac Mini (macOS) — media server

BREWS=(
    # deps
    go
    uv
    node pnpm oven-sh/bun/bun

    universal-ctags global pygments
    direnv
    ccls

    coreutils # gls
    pngpaste  # paste image in emacs telega
    librime   # emacs-rime
    mihomo    # /opt/homebrew/etc/mihomo/config.yaml.

    fd ripgrep fzf jq zoxide tealdeer
    rsync
    wget
    tree
    iperf
    ffmpeg

    # build from source
    pkgconf
    autoconf
    awk
    gnu-sed
    gnu-tar
    grep
    make
    texinfo
)

CASKS=(
    d12frosted/emacs-plus/emacs-plus-app@master
    google-chrome
    iterm2
    bitwarden
    karabiner-elements
    squirrel-app
    the-unarchiver
    dropbox
    iina
    keepingyouawake
    chatgpt codex
    claude
    folo
    temurin # jdk
    ngrok

    # server
    plex-media-server
    orbstack
)

FONT_CASKS=(
    # mono
    font-cascadia-code
    font-ibm-plex-mono
    # var
    font-cardo
    #cjk
    font-lxgw-wenkai
    font-sarasa-gothic
    font-source-han-sans-vf
    font-source-han-serif-vf
    # icons
    font-symbols-only-nerd-font
)

# Go tools installed via `go install`.
# Format: "<module>@<version>:<binary>"
GO_INSTALL_TOOLS=(
    golang.org/x/tools/cmd/goimports@latest
    golang.org/x/tools/gopls@latest
    honnef.co/go/tools/cmd/staticcheck@latest
    github.com/go-delve/delve/cmd/dlv@latest
    github.com/cweill/gotests/gotests@latest
    github.com/fatih/gomodifytags@latest
    github.com/davidrjenni/reftools/cmd/fillstruct@latest
)

# Python tools installed via `uv tool install`.
# Format: "<package>[:<binary>]"
UV_TOOLS=(
    ty@latest
    ruff@latest
)

# Node tools installed via `pnpm add -g`.
PNPM_GLOBAL_PACKAGES=(
    @google/gemini-cli
    @github/copilot-language-server
    @typescript/native-preview
    typescript-language-server
    svelte-language-server
    @tailwindcss/language-server
)

DOTFILES=(
    .zshrc
    .zshenv
    .gitconfig
    .globalrc
    .condarc
    .gitattributes
    .gitignore_global
    .cargo/config.toml
    .config/karabiner/karabiner.json
)
