{
  lib,
  inputs,
  config,
  pkgs,
  ...
}: {
  # macOS user
  users.users.liubo = {
    home = "/Users/liubo";
    # Default shell
    shell = pkgs.zsh;
  };

  networking = {
    computerName = "cmcm";
    hostName = "cmcm";
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      lxgw-wenkai
      # Mono font for English and Chinese
      sarasa-gothic
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];
  };

  homebrew = {
    enable = true;
    global.autoUpdate = true;
    # masApps = [];
    taps = [
      "homebrew/cask"
      "jimeh/emacs-builds"
    ];
    brews = [
      # nix 安装的 aspell 在 mac 上 command not found
      "aspell"
      # same as aspell
      "translate-shell"
      # paste image in emacs telega
      "pngpaste"
    ];
    casks = [
      "firefox"
      # for feishu doc, which is slow in firefox
      "chromium"
      # NOTE Say it!
      "clashx"
      "iina"
      "karabiner-elements"
      "raycast"
      "squirrel"
      "syncthing"
      "anki"
      "emacs-app-good"
      "discord"
      "dropbox"
      "netnewswire"
      "keepingyouawake"
      "the-unarchiver"
      # "goldendict-ng"
      # display monitor info on menu bar
      "stats"
    ];
  };

  # Config for all darwin system.
  environment.shells = [pkgs.zsh];
  programs.zsh.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["liubo"];
    };
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    # Enable nixFlakes on system
    package = pkgs.nixVersions.unstable;

    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    # nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
    registry.nixpkgs.flake = inputs.nixpkgs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = ["/etc/nix/path"];
  };
  # Together with nix.nixPath config.
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

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
