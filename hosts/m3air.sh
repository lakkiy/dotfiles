#!/usr/bin/env zsh
# hosts/m3air.sh — Minimal test profile for MacBook Air M3 (macOS)
#
# Keep this host intentionally small while validating installer behavior.
# After tests are stable, extend these arrays incrementally.

BREWS=(
    # deps
    go
    uv
    node pnpm

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
    d12frosted/emacs-plus/emacs-plus@31
    # build tdlib
    gperf cmake openssl

    # work
    awscli
)

CASKS=(
    zen
    iterm2
    bitwarden
    karabiner-elements
    squirrel-app
    the-unarchiver
    dropbox
    iina
    keepingyouawake
    folo
    chatgpt codex
    claude claude-code

    # work
    temurin ngrok
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
    @mariozechner/pi-coding-agent
    @typescript/native-preview
    typescript-language-server
    svelte-language-server
    @tailwindcss/language-server

    # work
    dynamodb-admin
)

DOTFILES=(
    .zshrc
    .gitconfig
    .globalrc
    .condarc
    .gitattributes
    .gitignore_global
    .cargo/config.toml
    .config/karabiner/karabiner.json
)
