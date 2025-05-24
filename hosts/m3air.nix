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

    nix.extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';

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

    # error: access to absolute path '/opt' is forbidden in pure evaluation mode (use '--impure' to override)
    # environment.systemPath = [
    #   /opt/homebrew/bin
    # ];

    homebrew = {
      enable = true;
      # masApps = [];
      taps = [
        "homebrew/services"
      ];
      brews = [
        "coreutils"
        "aspell" # nix 安装的 aspell 在 mac 上 command not found
        "pngpaste" # paste image in emacs telega
        "tree-sitter"
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
