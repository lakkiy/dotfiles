{ lib, inputs, config, pkgs, vars, ... }:

{
  users.users.${vars.user} = {
    home = "/Users/${vars.user}";
    shell = pkgs.zsh;
  };

  environment.shells = [ pkgs.zsh ];
  programs.zsh.enable = true;

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
    enable = true;
    global.autoUpdate = true;
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
      "chromium"       # for feishu doc, which is slow in firefox
      "iina"
      "karabiner-elements"
      "raycast"
      "squirrel"
      "syncthing"
      "anki"
      # "emacs-app-good"
      "discord"
      "dropbox"
      "netnewswire"
      "keepingyouawake"
      "the-unarchiver"
      # "goldendict-ng"
      "stats"       # display monitor info on menu bar
      "xournal-plus-plus"
      "inkscape" # draw
      "zotero@beta"

      # Unavaiable
      # NOTE Say it!
      # "clashx"

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

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix = {
    # Enable nixFlakes on system
    package = pkgs.nix;
    settings = {
      trusted-users = ["root" "mrunhap"];
      substituters = [
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://cache.nixos.org"
      ];
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  system = {
    # Since it's not possible to declare default shell, run this command
    # after build
    activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.zsh}/bin/zsh'';

    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 4;

    defaults = {
      trackpad = {
        Clicking = true;
        TrackpadRightClick = true;
        Dragging = true;
        TrackpadThreeFingerDrag = true;
      };
      NSGlobalDomain = {
        AppleShowAllFiles = true;
        AppleInterfaceStyleSwitchesAutomatically = true;
        NSAutomaticCapitalizationEnabled = false;
        NSDocumentSaveNewDocumentsToCloud = false;
        InitialKeyRepeat = 10;
        KeyRepeat = 1;
      };
      dock = {
        minimize-to-application = true;
        autohide = true;
      };
      finder = {
        AppleShowAllFiles = true;
        ShowStatusBar = true;
        ShowPathbar = true;
        QuitMenuItem = true;
      };
    };
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
  };
}
