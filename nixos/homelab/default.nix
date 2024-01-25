{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
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
        # plex
        32400
      ];
      allowedUDPPorts = [
        # syncthing
        22000 21027
        # plex
        32400
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

  # transmission
  # ip:9091
  services.transmission = {
    enable = true;
    user = "root";
    webHome = pkgs.flood-for-transmission;
    openFirewall = true;
    performanceNetParameters = true;
    openRPCPort = true; #Open firewall for RPC
    settings = { #Override default settings
      download-dir = "/mnt/share/Downloads";
      incomplete-dir = "/mnt/share/Downloads/.incomplete";
      watch-dir-enabled = true;
      watch-dir = "/mnt/share/Downloads/watch";
      rpc-bind-address = "0.0.0.0"; #Bind to own IP
      dht-enabled = false;
      pex-enabled = false;
      lpd-enabled = false;
      rpc-username = "mrunhap";
      rpc-password= "transmission";
      rpc-host-whitelist-enabled = false;
      rpc-whitelist-enabled = false;
    };
  };

  services.jackett = {
    enable = true;
    user = "root";
    openFirewall = true;
    dataDir = "/mnt/share/app/jackett";
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
