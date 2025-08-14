{ config, pkgs, lib, user, ... }: {
  # Host-specific home-manager configuration
  home-manager.users.${user} = {
    imports = [
      ../modules/home/dev.nix
    ];
    my.dev.enable = true;
    home.file.".config/karabiner/karabiner.json".source = ../static/karabiner.json;
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
      "coreutils" # gls
      "pngpaste"  # paste image in emacs telega
      "librime"   # emacs-rime
    ];
    casks = [
      "zen"
      "bitwarden"
      "karabiner-elements"
      "squirrel-app"
      "the-unarchiver"
      "raycast"
      "iterm2"
      "dropbox"
      "iina"
      "keepingyouawake"
      "folo"
      "zotero"
      "chatgpt" "claude" "claude-code"
    ];
  };
}
