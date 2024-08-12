{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.my.shell;

in {
  options.my.shell = {
    enable = mkEnableOption "shell";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      git wget
      progress # coreutils viewer
      gnumake neofetch just
      rsync delta fd cloc tree
      ast-grep
      inetutils # ftp client
      iperf # test preformance of network
      tailspin # highlight logs
      d2 # draw
      websocat # curl for websocket
      gdu # disk analyzer
      bandwidth # network monitor
      dufs # simple file server
      git-filter-repo
      # https://wiki.archlinux.org/title/Archiving_and_compression
      p7zip

      kubectl litecli mongosh mycli mosh pgcli

      # generate nix fetcher from url
      # $ nurl https://github.com/nix-community/patsh v0.2.0 2>/dev/null
      nurl
      # generate nix package from url, build on top of nurl
      nix-init
    ];

    home.sessionVariables = {
      LANG = "en_US.UTF-8";
      EDITOR = "emacsclient -a '' -nw";
      TERM = "xterm-256color";
      LC_CTYPE = "en_US.UTF-8";
      NIX_PATH = "$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels";
      # fix 500 error for localsend
      # https://github.com/localsend/localsend/issues/461#issuecomment-1715170140
      XDG_DOWNLOAD_DIR = "$HOME/Downloads";
    };
    home.sessionPath = [
      "$HOME/bin"
      "$HOME/.local/bin"
    ];

    programs = {
      man.enable = true;
      htop.enable = true;
      fzf.enable = true;
      ripgrep.enable = true;
      zoxide.enable = true;
      tealdeer.enable = true;
      jq.enable = true;
      pandoc.enable = true;
      direnv.enable = true;
      direnv.nix-direnv.enable = true;

      git = {
        enable = true;
        userName = "mrunhap";
        userEmail = "liubolovelife@gmail.com";
        delta.enable = true;
        lfs.enable = true;
        extraConfig = {
          init.defaultBranch = "master";
          pull.rebase = true;
          push.default = "current";
          diff.colorMoved = "default";
          merge.conflictStyle = "diff3";
          include.path = "$HOME/.gitconfig";
          credential.helper =
            if pkgs.stdenv.isLinux
            then "store"
            else "osxkeychain";
          github.user = "mrunhap";
        };
        ignores = [
          ".venv"
          "pyrightconfig.json"
          ".DS_Store"
          "*.bak"
          "*.log"
          "*.swp"
          "tags"
          "GPATH"
          "GRTAGS"
          "GTAGS"
          ".direnv"
          "node_modules"
          "bin"
          "__pycache__"
          "__pypackages__"
          "main"
        ];
      };

      zsh = {
        enable = true;
        defaultKeymap = "emacs";
        autocd = true;
        dotDir = ".config/zsh";
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        historySubstringSearch.enable = true;
        # https://martinheinz.dev/blog/110
        history = {
          size = 10000000;
          save = 10000000;
          ignorePatterns = [ "(ls|cd|pwd|exit|cd)*" ];
          ignoreAllDups = true;
          # This can be useful if you want to avoid storing secrets in
          # history - simply prefix any command that includes a
          # secret/password with space, e.g. export
          # AWS_ACCESS_KEY_ID=... (notice the space before export) and it
          # won't appear in history.
          ignoreSpace = true;
        };
        shellAliases = {
          grep = "grep --binary-files=without-match";
          ls = if pkgs.stdenv.isLinux
               then "ls --color --group-directories-first --human-readable --time-style=long-iso"
               else "gls --color --group-directories-first --human-readable --time-style=long-iso";
          ll = "ls -al";
          k = "kubectl";
          e = "emacs -nw";
          me = "emacs -q -nw -l ~/.emacs.d/init-mini.el";
          ec = ''emacsclient -nw -a ""'';
          kec = "emacsclient -e '(kill-emacs)'";
        };
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

        # For iterm2 shell integration
        [ -f $HOME/.config/zsh/.iterm2_shell_integration.zsh ] && source $HOME/.config/zsh/.iterm2_shell_integration.zsh

        # For local use.
        [ -f $HOME/.zshrc ] && source $HOME/.zshrc
      '';
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
              rev = "41cb143ccc3b8cc444bf20257276cb43275f65c4";
              sha256 = "sha256-ZFWrwcwwwSYP5d8k7Lr/hL3WKAZmgn51Q9hYL3bq9vE=";
            };
            file = "alias-tips.plugin.zsh";
          }
          {
            name = "git.plugin.zsh";
            src = fetchurl {
              url = "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/git/git.plugin.zsh";
              sha256 = "sha256-owgMEMBx86gQXIAI8a8lkOt7lo3eLJApsOQesk9w3pY=";
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
        ];
      };
    };
  };
}
