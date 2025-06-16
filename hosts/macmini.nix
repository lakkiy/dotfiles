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

    system.primaryUser = "${user}";

    home-manager.users.${user} = {
      home.homeDirectory = "/Users/${user}/"; # required
      home.file.".config/karabiner/karabiner.json".source = ../static/karabiner.json;
    };

    homebrew = {
      enable = true;
      casks = [
        "karabiner-elements"
        "squirrel"

	# server specific
        "plex-media-server"
      ];
    };
  };
}
