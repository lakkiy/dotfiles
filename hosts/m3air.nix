{
  nixpkgs,
  system,
  hostName,
  user,
}: {
  root = {
    system.stateVersion = 6;
  };

  module = {
    config,
    pkgs,
    lib,
    ...
  }: {
    imports = [];

    # Nix installation itself, you will need to set nix.enable = false; in your
    # configuration to disable nix-darwin’s own Nix management. Some nix-darwin
    # functionality that relies on managing the Nix installation, like the nix.*
    # options to adjust Nix settings or configure a Linux builder, will be
    # unavailable.
    nix.enable = false;
    system.primaryUser = "${user}";

    users.users.${user} = {
      home = "/Users/${user}";
      shell = pkgs.zsh;
    };

    home-manager.users.${user} = {
      home.file.".config/karabiner/karabiner.json".source = ../static/karabiner.json;
      my.dev.enable = true;
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
        "coreutils"
        "pngpaste" # paste image in emacs telega

        # this will be auto installed if build emacs from source with emacs-plus
        # "tree-sitter"
        # nix 安装的 aspell 在 mac 上 command not found
        # don't need spell check for now
        # "aspell"
      ];
      casks = [
        "iterm2"
        "zen"
        "karabiner-elements"
        "squirrel"
        "syncthing"
        "chatgpt"
        "raycast"

        "folo"
        "tencent-meeting"
        "zotero"
        "the-unarchiver"
        "iina"
        "dropbox"
        "keepingyouawake"
      ];
    };
  };
}
