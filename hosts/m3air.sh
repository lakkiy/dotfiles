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
    typescript
    typescript-language-server
    tailwindcss-language-server

    universal-ctags global pygments
    direnv
    ccls

    aria2
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

    # build tdlib
    gperf cmake openssl

    # work
    awscli
)

CASKS=(
    d12frosted/emacs-plus/emacs-plus-app@master
    google-chrome
    raycast
    proton-pass
    ghostty
    karabiner-elements
    squirrel-app
    dropbox
    iina
    keepingyouawake
    chatgpt codex codex-app
    claude claude-code@latest
    folo
    ngrok
    qq wechat
    copilot-language-server

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
    mlx-lm
    mlx-vlm
)

# Node tools installed via `pnpm add -g`.
PNPM_GLOBAL_PACKAGES=(
    svelte-language-server
)

BIN_DIRS=(
    bin
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
    .config/ghostty
)
