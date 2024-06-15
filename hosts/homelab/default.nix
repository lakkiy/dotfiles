{ config, lib, pkgs, outputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    outputs.nixosModules.qbittorrent-nox
  ];

  boot.loader.systemd-boot.enable = true;

  networking = {
    hostName = "homelab";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        # vsftpd
        2121
        # syncthing
        8384
        22000
        # photoprism
        2342
      ];
      allowedUDPPorts = [
        # syncthing
        22000
        21027
        # photoprism
        2342
      ];
    };
  };

  console.keyMap = "dvorak";
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    git
  ];

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";
  services.sshd.enable = true;

  # mount nas smb share dir, as root for now
  fileSystems."/mnt/share" = {
    device = "//192.168.31.203/share";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
      # username=<USERNAME>
      # domain=<DOMAIN>
      # password=<PASSWORD>
    in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
  };

  # https://tailscale.com/blog/nixos-minecraft
  # services.tailscale = {
  #   enable = true;
  #   openFirewall = true;
  #   permitCertUid = "root";
  #   useRoutingFeatures = "server";
  #   authKeyFile = "/run/secrets/tailscale_key";
  # };

  # NOTE can't work with sqlite on NFS
  services.qbittorrent-nox = {
    enable = true;
    user = "root";
    group = "root";
    web.openFirewall = true;
    torrenting.openFirewall = true;
  };

  services.plex = {
    enable = true;
    user = "root";
    group = "root";
    openFirewall = true;
  };

  services.vsftpd = {
    enable = true;
    writeEnable = true;
    localUsers = true;
    extraConfig = "
      listen_port=2121
    ";
  };

  services.syncthing = {
    enable = true;
    user = "root";
    extraFlags = ["--no-default-folder"];
    guiAddress = "0.0.0.0:8384";
    settings.gui = {
      enabled = true;
      user = "syncthing";
      password = "syncthing";
    };
  };

  # Photoprism
  services.photoprism = {
    enable = true;
    port = 2342;
    originalsPath = "/mnt/share/media/pictures";
    address = "0.0.0.0";
    settings = {
      PHOTOPRISM_ADMIN_USER = "admin";
      PHOTOPRISM_ADMIN_PASSWORD = "abcd_1234!";
      PHOTOPRISM_DEFAULT_LOCALE = "zh_CN";
      PHOTOPRISM_DATABASE_DRIVER = "mysql";
      PHOTOPRISM_DATABASE_NAME = "photoprism";
      PHOTOPRISM_DATABASE_SERVER = "/run/mysqld/mysqld.sock";
      PHOTOPRISM_DATABASE_USER = "photoprism";
    };
  };
  # MySQL
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureDatabases = ["photoprism"];
    ensureUsers = [
      {
        name = "photoprism";
        ensurePermissions = {
          "photoprism.*" = "ALL PRIVILEGES";
        };
      }
    ];
  };

  system.stateVersion = "23.11"; # Did you read the comment?

  # pt plugin plus is better
  services.ombi = {
    enable = false;
    user = "root";
    group = "root";
    openFirewall = true;
  };
  services.sonarr = {
    enable = false;
    user = "root";
    group = "root";
    openFirewall = true;
  };
  services.radarr = {
    enable = false;
    user = "root";
    group = "root";
    openFirewall = true;
  };
  services.jackett = {
    enable = false;
    user = "root";
    group = "root";
    openFirewall = true;
  };
  services.bazarr = {
    enable = false;
    user = "root";
    group = "root";
    openFirewall = true;
  };
}
