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
    cardo
    lxgw-wenkai
    sarasa-gothic
    nerd-fonts.symbols-only
  ];

  homebrew = {
    enable = true;
    taps = [];
    brews = [
      "coreutils" # gls
      "pngpaste" # paste image in emacs telega
    ];
    casks = [
      # required
      "zen"
      "bitwarden"
      "karabiner-elements"
      "squirrel"
      "the-unarchiver"
      "raycast"
      "iterm2"

      # apps
      "claude"
      "folo"
      "iina"
      "dropbox"
      "keepingyouawake"
      "zotero"
      "claude-code"
      "chatgpt"
      "send-to-kindle"

      # server specific
      "plex-media-server"
    ];
  };
}
