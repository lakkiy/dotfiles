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
      my.dev.enable = true;
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
        "coreutils"
        "aspell" # nix 安装的 aspell 在 mac 上 command not found
        "pngpaste" # paste image in emacs telega
        "tree-sitter"

        "aider"
        "basedpyright"
      ];
      casks = [
        "iterm2"
        "zen-browser"
        "karabiner-elements"
        "squirrel"
        "syncthing"
        "chatgpt"
        "raycast"

        "follow"
        "tencent-meeting"
        "zotero"
        "the-unarchiver"
        "iina"
        "dropbox"
        "keepingyouawake"

        # convert flac to alac
        "ffmpeg"
      ];
    };
  };
}
