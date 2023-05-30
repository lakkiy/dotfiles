{ config, pkgs, ... }:

let
  # https://nixos.wiki/wiki/TexLive
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic
      dvisvgm dvipng # for preview and export as html
      wrapfig amsmath ulem hyperref capt-of;
      #(setq org-latex-compiler "lualatex")
      #(setq org-preview-latex-default-process 'dvisvgm)
  });
in
{
  home.packages = with pkgs; [
    man
    gnumake
    neofetch
    btop                     # htop
    delta                    # diff
    fd                       # find
    ripgrep                  # grep
    ugrep                    # interactive grep
    cloc                     # count code line
    jq                       # process json
    mosh                     # udp ssh
    tealdeer                 # tldr
    tree                     # show folder as tree view
    plantuml                 # draw
    nodePackages.mermaid-cli # draw
    hunspell                 # spell check
    ltex-ls                  # lsp server
    tex                      # basic support for org mode
    mg

    # cli client
    kubectl
    litecli
    mongosh
    mycli

    # Extract
    cpio
    p7zip
    unrar
    unzip

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
    # EDITOR   = "emacsclient -a '' -nw";
    EDITOR   = "mg";
    TERM     = "xterm-256color";
    LC_CTYPE = "en_US.UTF-8";
    NIX_PATH = "$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels";
  };

  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
  ];

  programs = {
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
      };
      ignores = [
        ".DS_Store"
        "*.bak"
        "*.log"
        "*.swp"
        "tags"
        "GPATH"
        "GRTAGS"
        "GTAGS"
      ];
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f --hidden --follow --exclude .git || git ls-tree -r --name-only HEAD || rg --files --hidden --follow --glob '!.git' || find .";
      defaultOptions = [
        "--height 40%"
        "--layout=reverse"
      ];
      fileWidgetCommand = "${config.programs.fzf.defaultCommand}";
      fileWidgetOptions = [
        "--preview '(bat --style=plain --color=always {} || cat {} || tree -NC {}) 2> /dev/null | head -200"
      ];
      historyWidgetOptions = [
        "--preview 'echo {}'"
        "--preview-window down:3:hidden:wrap"
        "--bind '?:toggle-preview'"
        "--exact"
      ];
      changeDirWidgetOptions = [
        "--preview 'tree -NC {} | head -200"
      ];
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      defaultKeymap = "emacs";
      autocd = true;
      dotDir = ".config/zsh";
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      historySubstringSearch.enable = true;
      shellAliases = {
        ls = "ls --color --group-directories-first";
        ll = "ls -al --human-readable --time-style=long-iso";
        htop = "btop";
        diff = "delta";
        find = "fd";
        grep = "rg";
        k = "kubectl";
        e = "emacsclient -nw";
        te = "emacs -nw";
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
            sha256 = "sha256-9FgkH+GloY3uRZ6QZnaDa8+LLaQRhpbf+eC0NxglgDw=";
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
            sha256 = "sha256-uIBOFL+IcJrQd3eI5LyuJwq7G5lZlCEDq19gggkbsIQ=";
          };
        }
      ];
      initExtra = ''
for file in $HOME/.config/zsh/plugins/*.zsh; do
    source "$file"
done

PROMPT='%n@%m %1~ %# '

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export MOZ_ENABLE_WAYLAND=1
fi

# For local use.
[ -f $HOME/.zshrc ] && source $HOME/.zshrc
    '';
    };
  };
}
