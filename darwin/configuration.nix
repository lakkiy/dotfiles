{ config, pkgs, ... }:

{
  users.users.liubo = {               # macOS user
    home = "/Users/liubo";
    # shell = pkgs.zsh;                     # Default shell
  };

  networking = {
    computerName = "cmcm";             # Host name
    hostName = "cmcm";
  };

  fonts = {                               # Fonts
    fontDir.enable = true;
    fonts = with pkgs; [
      lxgw-wenkai # Chinese font
      sarasa-gothic # Mono font for English and Chinese
      cardo # variable pitch font
    ];
  };

  # environment.shells = [ pkgs.zsh ];          # Default shell
  # programs.zsh.enable = true;             # Shell needs to be enabled

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
      "emacs-app-good" # NOTE until emacs 29 version out
      "spotify"
      "easy-move-plus-resize" # use command + cursor to move window
      "anki"
      "clashx" # NOTE Say it!
      "balenaetcher"
      "discord"
      "docker"
      "dropbox"
      "firefox"
      "iina"
      "karabiner-elements"
      "keepingyouawake"
      "maczip"
      "netnewswire"
      "raycast"
      "squirrel"
      "syncthing"
      "the-unarchiver"
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
}
