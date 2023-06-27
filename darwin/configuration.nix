{ config, pkgs, ... }:

{
  users.users.liubo = {               # macOS user
    home = "/Users/liubo";
    shell = pkgs.zsh;                 # Default shell
  };
  environment.shells = [ pkgs.zsh ];  # Default shell
  programs.zsh.enable = true;         # Shell needs to be enabled

  networking = {
    computerName = "cmcm";             # Host name
    hostName = "cmcm";
  };

  fonts = {                               # Fonts
    fontDir.enable = true;
    fonts = with pkgs; [
      lxgw-wenkai # Chinese font
      sarasa-gothic # Mono font for English and Chinese
    ];
  };

  homebrew = {
    enable = true;
    taps = [
      "jimeh/emacs-builds"
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/core"
      "homebrew/services"
    ];
    casks = [
      "clashx" # NOTE Say it!
      "firefox"
      "iina"
      "karabiner-elements"
      "raycast"
      "squirrel"
      "syncthing"
      # "docker"
      "emacs-app-good" # NOTE until emacs 29 version out
      "anki"
      "discord"
      "dropbox"
      "netnewswire"
      "keepingyouawake"
      "maczip"
      "the-unarchiver"
      "easy-move-plus-resize" # use command + cursor to move window
      "via"
      # steptwo, safari extensions, plash
    ];
  };

  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    settings ={
      auto-optimise-store = true;           # Optimise syslinks
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {                                # Garbage collection
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
  };
  nixpkgs.config.allowUnfree = true;                    # Allow proprietary software.

  system = {
    defaults = {
      trackpad = {                        # Trackpad settings
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
    activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.zsh}/bin/zsh''; # Since it's not possible to declare default shell, run this command after build
    stateVersion = 4;
  };
}
