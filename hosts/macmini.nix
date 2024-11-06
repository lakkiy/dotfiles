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

    fonts.packages = with pkgs; [
      cardo
      lxgw-wenkai
      sarasa-gothic
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];

    environment.systemPath = [
      /opt/homebrew/bin
    ];
    homebrew = {
      enable = true;
      # masApps = [];
      taps = [
        "homebrew/services"
      ];
      brews = [
        "coreutils" # gls
      ];
      casks = [
        "zen-browser"
        "karabiner-elements"
        "squirrel"
        "syncthing"
        "plex-media-server"
        "orbstack"
      ];
    };
  };
}
