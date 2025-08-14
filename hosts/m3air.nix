{ config, pkgs, lib, user, ... }: {
  # Host-specific user configuration
  users.users.${user} = {
    shell = pkgs.zsh;  # m3air specific: set zsh as default shell
  };

  # Host-specific home-manager configuration
  home-manager.users.${user} = {
    imports = [
      ../modules/home/dev.nix
    ];
    home.file.".config/karabiner/karabiner.json".source = ../static/karabiner.json;
    my.dev.enable = true;
  };

  fonts.packages = with pkgs; [
    cascadia-code
    ibm-plex

    # variable
    cardo

    # CJK
    lxgw-wenkai
    sarasa-gothic
    source-han-sans
    source-han-serif

    # icons & backup font
    nerd-fonts.symbols-only
  ];

  homebrew = {
    enable = true;
    taps = [];
    brews = [
      "coreutils"
      "pngpaste" # paste image in emacs telega

      # this will be auto installed if build emacs from source with emacs-plus
      # "tree-sitter"
      # nix 安装的 aspell 在 mac 上 command not found
      # don't need spell check for now
      # "aspell"
    ];
    casks = [
      "keepingyouawake"
      "the-unarchiver"
      "iterm2"
      "zen"
      "karabiner-elements"
      "squirrel"
      "raycast"

      "dropbox"
      "chatgpt"
      "folo"
      "iina"
    ];
  };
}
