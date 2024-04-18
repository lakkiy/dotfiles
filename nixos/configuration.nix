# General configuration.nix for all host
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # Always enable the shell system-wide, even if it's already enabled in
  # your home.nix. # Otherwise it wont source the necessary files.
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  # get zsh completion for system packages (e.g. systemd)
  environment.pathsToLink = [ "/share/zsh" ];
  # Many programs look at /etc/shells to determine if a user is a
  # "normal" user and not a "system" user. Therefore it is recommended
  # to add the user shells to this list. To add a shell to /etc/shells
  # use the following line in your config:
  environment.shells = with pkgs; [zsh];

  environment.systemPackages = [
    pkgs.git
    # FHS environment
    (let
      base = pkgs.appimageTools.defaultFhsEnvArgs;
    in
      pkgs.buildFHSUserEnv (base
        // {
          name = "fhs";
          targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [pkgs.pkg-config];
          profile = "export FHS=1";
          runScript = "bash";
          extraOutputsToInstall = ["dev"];
        }))
    # For mount samba
    pkgs.cifs-utils
  ];

  # Set timezone
  time.timeZone = "Asia/Shanghai";

  # Set locale
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Set keyboard repat, rate = 60
  services.xserver.autoRepeatInterval = 60;
  services.xserver.autoRepeatDelay = 120;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "dvorak";
  };

  # Configure console keymap
  console.keyMap = "dvorak";

  # Use keyd to remap keys
  services.keyd.enable = true;
  services.keyd.keyboards.default = {
    ids = ["*"];
    settings = {
      main = {
        capslock = "overload(control, esc)";
        control = "overload(control, esc)";
      };
    };
  };

  nix = {
    settings = {
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      # Enable flakes and new 'nix' command
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "liubo" "mrunhap"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2d";
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

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      # outputs.overlays.additions
      # outputs.overlays.modifications
      # outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Allow proprietary software.
    config.allowUnfree = true;
  };

  system.stateVersion = "23.11";
}
