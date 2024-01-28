{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/nixos/services/qbittorrent.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking = {
    hostName = "nixos-homelab";
    networkmanager.enable = true;
    defaultGateway = "192.168.31.222";
    nameservers = [ "192.168.31.222" ];
    interfaces.ens192.ipv4.addresses = [{
      address = "192.168.31.52";
      prefixLength = 24;
    }];
    firewall = {
      enable = true;
      allowedTCPPorts = [
        # vsftpd
        2121
        # syncthing
        8384 22000
      ];
      allowedUDPPorts = [
        # syncthing
        22000 21027
      ];
    };
  };

  environment.systemPackages = with pkgs; [git
  ];

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";
  services.sshd.enable = true;

  # mount nas smb share dir, as root for now
  fileSystems."/mnt/share" = {
    device = "//192.168.31.61/share";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

      # username=<USERNAME>
      # domain=<DOMAIN>
      # password=<PASSWORD>
    in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
  };

  services.qbittorrent-nox = {
    enable = true;
    user = "root";
    group = "root";
    web.openFirewall = true;
    torrenting.openFirewall = true;
    dataDir = "/mnt/share/app/qbittorrent";
  };

  # TODO config
  services.ombi = {
    enable = true;
    user = "root";
    group = "root";
    openFirewall = true;
    dataDir = "/mnt/share/app/ombi";
  };
  services.sonarr = {
    enable = true;
    user = "root";
    group = "root";
    openFirewall = true;
    dataDir = "/mnt/share/app/sonarr";
  };
  services.radarr = {
    enable = true;
    user = "root";
    group = "root";
    openFirewall = true;
    dataDir = "/mnt/share/app/radarr";
  };
  services.jackett = {
    enable = true;
    user = "root";
    group = "root";
    openFirewall = true;
    dataDir = "/mnt/share/app/jackett";
  };
  services.bazarr = {
    enable = true;
    user = "root";
    group = "root";
    openFirewall = true;
  };

  # vsftpd
  services.vsftpd = {
    enable = true;
    writeEnable = true;
    localUsers = true;
    # make sure add port to networking.firewall.allowedTCPPorts
    extraConfig = "
      listen_port=2121
    ";
  };

  # syncthing
  services.syncthing = {
    enable = true;
    user = "root";
    configDir = "/mnt/share/app/syncthing/config";
    databaseDir = "/mnt/share/app/syncthing/database";
    extraFlags = [ "--no-default-folder" ];
    guiAddress = "0.0.0.0:8384";
    settings.gui = {
      enabled = true;
      user = "syncthing";
      password = "syncthing";
    };
  };

  # plex
  # http://ip:32400/web
  services.plex = {
    enable = true;
    user = "root";
    group = "root";
    openFirewall = true;
    dataDir = "/mnt/share/app/plex";
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
