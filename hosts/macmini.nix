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
    # 必须要在 nix-darwin 和 home-manager 中都指定用户目录
    users.users.${user}.home = "/Users/${user}";
    home-manager.users.${user}.home.homeDirectory = "/Users/${user}";

    home-manager.users.${user}.home.file = {
      ".config/karabiner/karabiner.json".source = ../static/karabiner.json;
    };

    homebrew = {
      enable = true;
      brews = [
        "coreutils"
      ];
      casks = [
        "zen"
        "bitwarden"
        "karabiner-elements"
        "squirrel"

	      # server specific
        "plex-media-server"
      ];
    };
  };
}
