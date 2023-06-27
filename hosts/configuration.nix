# General configuration.nix for all host
{ config, lib, pkgs, inputs, user, ...}:

{
  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "en_US.UTF-8";

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "dvorak";
  };

  # Configure console keymap
  console.keyMap = "dvorak";

  services.keyd.enable = true;
  services.keyd.ids = [ "*" ];
  services.keyd.settings = {
    main = {
      capslock = "overload(control, esc)";
      control = "overload(control, esc)";
    };
  };

  # Always enable the shell system-wide, even if it's already enabled in your home.nix. # Otherwise it wont source the necessary files.
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  # Many programs look at /etc/shells to determine if a user is a "normal" user and not a "system" user. Therefore it is recommended to add the user shells to this list. To add a shell to /etc/shells use the following line in your config:
  environment.shells = with pkgs; [ zsh ];

  environment.systemPackages = with pkgs; [
    git

    # https://unix.stackexchange.com/questions/522822/different-methods-to-run-a-non-nixos-executable-on-nixos
    steam-run # run commands in the same FHS env
  ];

  nix = {                                   # Nix Package Manager settings
    settings ={
      auto-optimise-store = true;           # Optimise syslinks
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {                                  # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
    };
    package = pkgs.nixVersions.unstable;    # Enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
  };
  nixpkgs.config.allowUnfree = true;        # Allow proprietary software.

  system.stateVersion = "23.05";
}
