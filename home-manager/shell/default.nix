{
  config,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    gnumake neofetch
    rsync delta fd cloc tree
    inetutils # ftp client
    iperf # test preformance of network
    tailspin # highlight logs
    d2 # draw
    websocat # curl for websocket
    # https://wiki.archlinux.org/title/Archiving_and_compression
    p7zip

    kubectl litecli mongosh mycli mosh

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
        path = "$HOME/Sync/.zsh_history";
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
        ls =
          if pkgs.stdenv.isLinux
          then "ls --color --group-directories-first"
          else "ls --color";
        ll = "ls -al --human-readable --time-style=long-iso";
        k = "kubectl";
        e = "emacs -nw";
        me = "emacs -q -nw -l ~/.config/emacs/init-mini.el";
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
          name = "git.plugin.zsh";
          src = fetchurl {
            url = "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/git/git.plugin.zsh";
            sha256 = "sha256-CuHFFH8zD35p8ujSbmc9kdbQtM8gFPN7vgCJ152swv8=";
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
}
