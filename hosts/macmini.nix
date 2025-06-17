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

    # required
    # Nix installation itself, you will need to set nix.enable = false; in your
    # configuration to disable nix-darwin’s own Nix management. Some nix-darwin
    # functionality that relies on managing the Nix installation, like the nix.*
    # options to adjust Nix settings or configure a Linux builder, will be
    # unavailable.
    nix.enable = false;
    system.primaryUser = "${user}";

    users.users.${user} = {
      home = "/Users/${user}"; # required
    };

    home-manager.users.${user} = {
      home.homeDirectory = "/Users/${user}"; # required
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
        "syncthing"

        # apps
        "claude"
        "folo"
        "iina"
        "dropbox"
        "keepingyouawake"
        "zotero"

	      # server specific
        "plex-media-server"
      ];
    };
  };
}
