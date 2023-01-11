{ config, pkgs, ... }:

{
  users.users.artorias = {               # macOS user
    home = "/Users/artorias";
    # shell = pkgs.zsh;                     # Default shell
  };

  networking = {
    computerName = "cmcm";             # Host name
    hostName = "cmcm";
  };

  fonts = {                               # Fonts
    fontDir.enable = true;
    fonts = with pkgs; [
      lxgw-wenkai
      jetbrains-mono
      symbola
      sarasa-gothic
      source-han-serif
      roboto-mono
      ibm-plex
      cardo
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
      "homebrew/core" # TODO maybe delete this
      "homebrew/bundle"
      "homebrew/services"
    ];
    casks = [
      "emacs-app-good"
      "spotify"
      "easy-move-plus-resize"
      "anki"
      "clashx-pro" # NOTE Say it!
      "balenaetcher"
      "discord"
      "docker"
      "dropbox"
      "firefox"
      "iina"
      "karabiner-elements"
      "keepingyouawake"
      "maczip"
      "miniconda"
      "netnewswire"
      "raycast"
      "squirrel"
      "syncthing"
      "the-unarchiver"
      "via"
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
