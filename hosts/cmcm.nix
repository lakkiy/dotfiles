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

    users.users.${user} = {
      home = "/Users/${user}";
      shell = pkgs.zsh;
    };

    home-manager.users.${user} = {
      home.file.".config/karabiner/karabiner.json".source = ../static/karabiner.json;
      my.dev.enable = true;
    };

    fonts.packages = with pkgs; [
      # mono
      lmodern
      roboto-mono
      dejavu_fonts
      ibm-plex

      # var
      cardo

      # 中文字体
      lxgw-wenkai

      # 中英等宽
      sarasa-gothic
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];

    homebrew = {
      # masApps = [];
      taps = [
        "jimeh/emacs-builds"
      ];
      brews = [
        "coreutils"
        "aspell" # nix 安装的 aspell 在 mac 上 command not found
        "pngpaste" # paste image in emacs telega
        "tree-sitter"
      ];
      casks = [
        "iterm2" # better search and filter
        "firefox"
        "chromium" # for feishu doc, which is slow in firefox
        "iina"
        "karabiner-elements"
        "raycast"
        "squirrel"
        "syncthing"
        # "emacs-app-good"
        "dropbox"
        "keepingyouawake"
        "the-unarchiver"
        "stats" # display monitor info on menu bar
        "xournal-plus-plus"
        "inkscape" # draw
        "zotero@beta"

        # TODO split into default and work config
        "feishu"
        "tencent-meeting"
        "mongodb-compass"
        "easy-move-plus-resize"
        "openlens"
        "qq"
        "wechat"
      ];
    };
  };
}
