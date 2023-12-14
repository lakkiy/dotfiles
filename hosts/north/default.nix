{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/nixos/nvidia.nix
      ../../modules/nixos/fcitx5.nix
      # ../../modules/nixos/gnome.nix
      ../../modules/nixos/hyprland.nix
      ../../modules/nixos/browser.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "north";
    networkmanager.enable = true;
    defaultGateway = "192.168.31.222";
    nameservers = [ "192.168.31.222" ];
    interfaces.wlp9s0.ipv4.addresses = [{
      address = "192.168.31.151";
      prefixLength = 24;
    }];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gray = {
    isNormalUser = true;
    description = "gray";
    extraGroups = [ "docker" "networkmanager" "wheel" ];
    packages = with pkgs; [
      steam
      mpv
      plex-media-player
      qbittorrent
      crow-translate
      ventoy
      butane
      cider
      localsend
      # dropbox version can't login
      obs-studio
    ];
  };
  virtualisation.docker.enable = true;

  environment.systemPackages = [
    (let base = pkgs.appimageTools.defaultFhsEnvArgs; in
     pkgs.buildFHSUserEnv (base // {
       name = "fhs";
       targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [pkgs.pkg-config];
       profile = "export FHS=1";
       runScript = "bash";
       extraOutputsToInstall = ["dev"];
     }))
  ];


  services.daed = {
    enable = true;
    configDir = "/etc/daed";
    listen = "0.0.0.0:2023";
    openFirewall = {
      enable = true;
      port = 12345;
    };
  };

  # services.dae = {
  #   enable = true;
  #   disableTxChecksumIpGeneric = false;
  #   configFile = "/etc/dae/config.dae";
  #   assets = with pkgs; [ v2ray-geoip v2ray-domain-list-community ];
  #   openFirewall = {
  #     enable = true;
  #     port = 12345;
  #   };
  # };

  system.stateVersion = "23.05";
}
