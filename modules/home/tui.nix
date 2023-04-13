{ config, pkgs, ... }:

let
  omz = "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/";
in
{
  home.packages = with pkgs; [
    delta # diff
    fd # find
    ripgrep # grep
    cloc
    gnumake
    jq
    kubectl
    litecli
    mongosh
    man
    mosh
    mycli
    neofetch
    tealdeer
    tree
    plantuml-c4
    hunspell
    ltex-ls

    # Extract
    cpio
    p7zip
    unrar
    unzip
  ];

  home.sessionVariables = {
    LANG     = "en_US.UTF-8";
    EDITOR   = "emacs -nw";
    TERM     = "xterm-256color";
    LC_CTYPE = "en_US.UTF-8";
    NIX_PATH = "$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels";
  };

  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
  ];

  programs = {
    btop.enable = true;

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
        l = "ls -alh";
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
          name = "alias-tips";
          src = fetchFromGitHub {
            owner = "djui";
            repo = "alias-tips";
            rev = "4d2cf6f10e5080f3273be06b9801e1fd1f25d28d";
            sha256 = "1bwr1dbh0szq4yrvlg27i2wls0q41sfk5qff27nqas1bjc587pfh";
          };
          file = "alias-tips.plugin.zsh";
        }
        # FIXME this should in a directory, can't source single file
        # {
        #   name = "git";
        #   src = fetchurl {
        #     url = omz + "git/git.plugin.zsh";
        #     sha256 = "sha256-P/jX4VG24u1wE0MLISWNBulzKPaYjheYvxyRcX4K9n4=";
        #   };
        #   file = "git.plugin.zsh";
        # }
        # {
        #   name = "common-aliases";
        #   src = fetchurl {
        #     url = omz + "common-aliases/common-aliases.plugin.zsh";
        #     sha256 = "sha256-xiAG25wQJkYcM9+unDNkbxLwNP7x5G4ZmNIOqYjiMrs=";
        #   };
        #   file = "common-aliases.plugin.zsh";
        # }
        # {
        #   name = "fancy-ctrl-z.plugin.zsh";
        #   src = fetchurl {
        #     url = omz + "fancy-ctrl-z/fancy-ctrl-z.plugin.zsh";
        #     sha256 = "sha256-oWhQdSDE6unkd6+dg3MlNudvoJdhNqJciLDPE5beWes=";
        #   };
        #   file = "fancy-ctrl-z.plugin.zsh";
        # }
        # {
        #   name = "extract.plugin.zsh";
        #   src = fetchurl {
        #     url = omz + "extract/extract.plugin.zsh";
        #     sha256 = "sha256-kktCH8wW23Riz9kMkGhLWtWym/wzvB9eSmmNe75seZg=";
        #   };
        #   file = "extract.plugin.zsh";
        # }
      ];
      initExtra = ''
PROMPT='[%n@%m %2~]%# '

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    export MOZ_ENABLE_WAYLAND=1
fi

# For local use.
[ -f $HOME/.zshrc ] && source $HOME/.zshrc
    '';
    };
  };
}
