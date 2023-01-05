{ config, pkgs, ... }:

let
  omz = "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/";
in
{
  programs.zsh = {
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
      e = "emacsclient -nc";
      te = "emacs -nw";
    };
    plugins = with pkgs; [
      {
        name = "jovial";
        src = fetchFromGitHub {
          owner = "zthxxx";
          repo = "jovial";
          rev = "v2.3.1";
          sha256 = "1kcg56ppw0wpf4ybvpvdwsk3zvvz5bysb2i4fx03rp1458jm6jjh";
        };
        file = "jovial.zsh-theme";
      }
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
      {
        name = "git";
        src = fetchurl {
          url = omz + "git/git.plugin.zsh";
          sha256 = "sha256-P/jX4VG24u1wE0MLISWNBulzKPaYjheYvxyRcX4K9n4=";
        };
        file = "git.plugin.zsh";
      }
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
[ -n "$EAT_SHELL_INTEGRATION_DIR" ] && \
  source "$EAT_SHELL_INTEGRATION_DIR/bash"

# For local use.
[ -f $HOME/.zshrc ] && source $HOME/.zshrc
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git || git ls-tree -r --name-only HEAD || rg --files --hidden --follow --glob '!.git' || find .";
    defaultOptions = [
      "--height 40% --layout=reverse"
      "--color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78"
      "--color=marker:#dc8a78,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39"
    ];
    fileWidgetCommand = "${config.programs.fzf.defaultCommand}";
    fileWidgetOptions = [ "--preview '(bat --style=plain --color=always {} || cat {} || tree -NC {}) 2> /dev/null | head -200" ];
    historyWidgetOptions = [ "--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --exact" ];
    changeDirWidgetOptions = [ "--preview 'tree -NC {} | head -200" ];
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    delta
    fd
    ripgrep
  ];

  home.sessionVariables = {
    EDITOR   = "emacs -nw";
    LANG     = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    TERM     = "xterm-256color";
    NIX_PATH = "$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels";
  };
  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
  ];
}
