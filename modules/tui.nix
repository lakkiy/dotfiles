{ config, pkgs, ... }:

let
  # https://nixos.wiki/wiki/TexLive
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-small
      dvisvgm dvipng # for preview and export as html
      wrapfig amsmath ulem hyperref capt-of
      #(setq org-latex-compiler "xelatex")
      #(setq org-preview-latex-default-process 'dvisvgm)
      digestif # lsp server
      ctex;
  });
in
{
  home.packages = with pkgs; [
    man
    gnumake
    neofetch
    htop
    delta                    # diff
    fd                       # find
    ripgrep                  # grep
    ugrep                    # faster than ripgrep
    cloc                     # count code line
    jq                       # process json
    tealdeer                 # tldr
    tree                     # show folder as tree view
    d2                       # draw
    iperf                    # test preformance of network
    tailspin                 # highlight logs
    websocat                 # curl for websocket
    pandoc

    # cli for emacs
    tex                      # basic support for org mode
    tikzit                   # draw
    ltex-ls                  # lsp server
    w3m                      # read html mail in emacs
    readability-cli          # firefox reader mode, for emacs eww

    # cli client
    kubectl
    litecli
    mongosh
    mycli
    mosh

    # https://wiki.archlinux.org/title/Archiving_and_compression
    p7zip

    # nix tools
    nurl # generate nix fetcher from url
    # $ nurl https://github.com/nix-community/patsh v0.2.0 2>/dev/null
    # fetchFromGitHub {
    #   owner = "nix-community";
    #   repo = "patsh";
    #   rev = "v0.2.0";
    #   hash = "sha256-7HXJspebluQeejKYmVA7sy/F3dtU1gc4eAbKiPexMMA=";
    # }
    nix-init # generate nix package from url, build on top of nurl
  ];

  home.sessionVariables = {
    LANG     = "en_US.UTF-8";
    EDITOR   = "emacsclient -a '' -nw";
    TERM     = "xterm-256color";
    LC_CTYPE = "en_US.UTF-8";
    NIX_PATH = "$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels";
  };

  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
  ];

  programs = {
    fzf.enable = true;
    zoxide.enable = true;
    direnv.enable = true;
    direnv.nix-direnv.enable = true;

    git = {
      enable = true;
      userName = "404cn";
      userEmail = "liubolovelife@gmail.com";
      delta.enable = true;
      extraConfig = {
        pull.rebase = true;
        push.default = "current";
        diff.colorMoved = "default";
        merge.conflictStyle = "diff3";
        include.path = "$HOME/.gitconfig";
        credential.helper = if pkgs.stdenv.isLinux then "store" else "osxkeychain";
        github.user = "404cn";
      };
      ignores = [
        ".DS_Store"
        "*.bak" "*.log" "*.swp"
        "tags" "GPATH" "GRTAGS" "GTAGS"
        ".direnv"
        "node_modules"
      ];
    };

    zsh = {
      enable = true;
      defaultKeymap = "emacs";
      autocd = true;
      dotDir = ".config/zsh";
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      historySubstringSearch.enable = true;
      shellAliases = {
        ls = if pkgs.stdenv.isLinux then "ls --color --group-directories-first" else "ls --color";
        ll = "ls -al --human-readable --time-style=long-iso";
        k = "kubectl";
        e = "emacs";
        te = "emacs -nw";
        ec = ''emacsclient -c -a ""'';
        tec = ''emacsclient -nw -a ""'';
        npm = "pnpm";
        # https://github.com/Genivia/ugrep#equivalence-to-gnubsd-grep
        grep = "ugrep -G -U -Y -. --sort -Dread -dread";
      };
      plugins = with pkgs; [
        {
          name = "zsh-autopair";
          src = fetchFromGitHub {
            owner = "hlissner";
            repo = "zsh-autopair";
            rev = "396c38a7468458ba29011f2ad4112e4fd35f78e6";
            sha256 = "0q9wg8jlhlz2xn08rdml6fljglqd1a2gbdp063c8b8ay24zz2w9x";
          };
          file = "autopair.zsh";
        }
        {
          name = "git.plugin.zsh";
          src = fetchurl {
            url = "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/git/git.plugin.zsh";
            sha256 = "sha256-Bp9iv0eQspO6kQfUTig4pznZ7Lw6GrU2oDUpfkbrIHc=";
          };
        }
        {
          name = "common-aliases.plugin.zsh";
          src = fetchurl {
            url = "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/common-aliases/common-aliases.plugin.zsh";
            sha256 = "sha256-xiAG25wQJkYcM9+unDNkbxLwNP7x5G4ZmNIOqYjiMrs=";
          };
        }
        {
          name = "fancy-ctrl-z.plugin.zsh";
          src = fetchurl {
            url = "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/fancy-ctrl-z/fancy-ctrl-z.plugin.zsh";
            sha256 = "sha256-oWhQdSDE6unkd6+dg3MlNudvoJdhNqJciLDPE5beWes=";
          };
        }
        {
          name = "extract.plugin.zsh";
          src = fetchurl {
            url = "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/extract/extract.plugin.zsh";
            sha256 = "sha256-hOzpvaIya3Nw6JweS10u5ekLAh7ym9K3sSMGkc2gNJU=";
          };
        }
      ];
      initExtra = ''
for file in $HOME/.config/zsh/plugins/*.zsh; do
    source "$file"
done

PROMPT='%F{green}[%n@%m:%~]%#%f '

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export MOZ_ENABLE_WAYLAND=1
fi

# For emacs eat
[ -n "$EAT_SHELL_INTEGRATION_DIR" ] && \
  source "$EAT_SHELL_INTEGRATION_DIR/zsh"

# For local use.
[ -f $HOME/.zshrc ] && source $HOME/.zshrc
    '';
    };
  };
}
