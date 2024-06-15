{ inputs, outputs, lib, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "north";
    networkmanager.enable = true;
    # interfaces.eno1.ipv4.addresses = [{
    #   address = "192.168.31.200";
    #   prefixLength = 24;
    # }];
    # interfaces.wlp9s0.ipv4.addresses = [{
    #   address = "192.168.31.4";
    #   prefixLength = 24;
    # }];
    # defaultGateway = {
    #   address = "192.168.31.222";
    #   interface = "wlp9s0";
    # };
    # nameservers = ["192.168.31.222"];
    firewall = {
      enable = true;
      allowedTCPPorts = [
        # localsend
        53317
        # vsftpd
        2121
      ];
      allowedUDPPorts = [ 53317 ];
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Pipewire && Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  # Remove sound.enable or set it to false if you had it set previously,
  # as sound.enable is only meant for ALSA-based configurations.
  sound.enable = false;
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
        bluez_monitor.properties = {
        	["bluez5.enable-sbc-xq"] = true,
        	["bluez5.enable-msbc"] = true,
        	["bluez5.enable-hw-volume"] = true,
        	["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
        }
      '')
    ];
  };

  # For dual boot must disable windows's hibernate
  services.logind.powerKey = "hibernate";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mrunhap = {
    isNormalUser = true;
    description = "mrunhap";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      mpv plex-media-player
      qbittorrent
      obs-studio
      ventoy
      cider
      discord
      goldendict-ng
      anki-bin anki-sync-server
      ruffle

      # open source dropbox cli and gui
      # can't use dropbox since it can't login
      maestral maestral-gui

      localsend xdg-user-dirs

      # best linux app
      blender
      gimp
      inkscape
      xournalpp
      filezilla
      audacious audacious-plugins
      pidgin
      # from gnome
      amberol # music player
      gnome.dconf-editor
      gnome.nautilus nautilus-open-any-terminal gnome.sushi
      gnome.gnome-disk-utility baobab gnome.gnome-system-monitor # disk
      loupe # image viewer
      gnome.evince # document viewer
      komikku # comic reader
      cartridges # game launcher
   ];
  };
  # for fractal
  services.gnome.gnome-keyring.enable = true;

  # mount nas smb share dir
  fileSystems."/mnt/share" = {
    device = "//192.168.31.203/share";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      # username=<USERNAME>
      # domain=<DOMAIN>
      # password=<PASSWORD>
    in ["${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100"];
  };

  # wayland support for electron base app
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

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

  # timezone & locale
  time.timeZone = "Asia/Shanghai";
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

  # Configure console keymap
  console.keyMap = "dvorak";

  services.xserver = {
    enable = true;
    # Set keyboard repat, rate = 60
    autoRepeatInterval = 60;
    autoRepeatDelay = 120;
    xkb.layout = "us";
    xkb.variant = "dvorak";
  };

  # Use keyd to remap keys
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = ["*"];
      settings = {
        main = {
          capslock = "overload(control, esc)";
          control = "overload(control, esc)";
        };
      };
    };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.trusted-users = ["root" "mrunhap"];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "23.11";
}
