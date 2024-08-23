{
  nixpkgs,
  system,
  hostName,
  user,
}: {
  root = {
    system.stateVersion = 4;
  };

  module = {
    config,
    pkgs,
    lib,
    ...
  }: {
    imports = [];

    nix.extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';

    users.users.${user} = {
      home = "/Users/${user}";
      shell = pkgs.zsh;
    };

    home-manager.users.${user} = {
      home.file.".config/karabiner/karabiner.json".source = ../static/karabiner.json;
    };

    homebrew = {
      # masApps = [];
      taps = [
        "homebrew/services"
      ];
      brews = [
      ];
      casks = [
        "karabiner-elements"
        "squirrel"
        "syncthing"
        "dropbox"
        "stats"

        "chatgpt"
        "plex"
        "plex-htpc"
        "plex-media-server"
      ];
    };
  };
}
