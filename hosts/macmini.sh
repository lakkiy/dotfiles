#!/usr/bin/env zsh
# hosts/macmini.sh — Mac Mini (macOS) — media server

BREWS=(
    # deps
    go
    uv
    node pnpm oven-sh/bun/bun
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

    cliproxyapi
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
    temurin # jdk
    ngrok
    qq wechat
    copilot-language-server

    # server
    plex-media-server
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
)

# Node tools installed via `pnpm add -g`.
PNPM_GLOBAL_PACKAGES=(
    svelte-language-server
)

# Personal script directories (repo-relative) to prepend to PATH.
# Scripts keep their filename, e.g. bin/hfd.sh -> run as `hfd.sh`.
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
