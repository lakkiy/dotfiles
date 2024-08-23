{
  nixpkgs,
  system,
  hostName,
  user,
}: {
  root = {
    imports = [];

    boot.initrd.availableKernelModules = ["ata_piix" "mptspi" "uhci_hcd" "ehci_pci" "sd_mod" "sr_mod"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = [];
    boot.extraModulePackages = [];

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/a4fc6ac3-9cbf-4cf7-86fe-20b7bc75e03c";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/6753-4869";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/8463e348-3914-46d8-918f-fa1ad0425485";}
    ];

    fileSystems."/mnt/share" = {
      device = "//192.168.31.203/share";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        username = "share";
        password = "share";
      in ["${automount_opts},username=${username},password=${password}"];
    };
  };

  module = {
    pkgs,
    config,
    lib,
    ...
  }: {
    system.stateVersion = "24.05";
    networking.useDHCP = lib.mkDefault true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    # Use the systemd-boot EFI boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

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

    security.sudo.wheelNeedsPassword = false;
    services.openssh.settings.PermitRootLogin = "yes";
    services.sshd.enable = true;

    environment.systemPackages = with pkgs; [
      pkgs.cifs-utils
    ];

    # https://unix.stackexchange.com/questions/731364/transmission-cant-access-mount-read-only-file-system
    systemd.services.transmission.serviceConfig.BindPaths = ["/mnt/share"];
    services.transmission = {
      enable = true;
      openRPCPort = true;
      webHome = pkgs.flood-for-transmission;
      user = "root";
      group = "root";
      performanceNetParameters = true;
      settings = {
        rpc-bind-address = "0.0.0.0";
        rpc-whitelist-enabled = false;
        download-dir = "/mnt/share/downloads";
        incomplete-dir-enabled = false;
        dht-enabled = false;
        pex-enabled = false;
        lpd-enabled = false;
      };
    };

    services.vsftpd = {
      enable = true;
      writeEnable = true;
      localUsers = true;
      extraConfig = "
      listen_port=2121
    ";
    };

    # services.plex = {
    #   enable = true;
    #   user = "root";
    #   group = "root";
    #   openFirewall = true;
    # };
    # services.syncthing = {
    #   enable = true;
    #   user = "root";
    #   extraFlags = ["--no-default-folder"];
    #   guiAddress = "0.0.0.0:8384";
    #   settings.gui = {
    #     enabled = true;
    #     user = "syncthing";
    #     password = "syncthing";
    #   };
    # };
    # pt plugin plus is better
    # services.ombi = {
    #   enable = false;
    #   user = "root";
    #   group = "root";
    #   openFirewall = true;
    # };
    # services.sonarr = {
    #   enable = false;
    #   user = "root";
    #   group = "root";
    #   openFirewall = true;
    # };
    # services.radarr = {
    #   enable = false;
    #   user = "root";
    #   group = "root";
    #   openFirewall = true;
    # };
    # services.jackett = {
    #   enable = false;
    #   user = "root";
    #   group = "root";
    #   openFirewall = true;
    # };
    # services.bazarr = {
    #   enable = false;
    #   user = "root";
    #   group = "root";
    #   openFirewall = true;
    # };
    # https://tailscale.com/blog/nixos-minecraft
    # services.tailscale = {
    #   enable = true;
    #   openFirewall = true;
    #   permitCertUid = "root";
    #   useRoutingFeatures = "server";
    #   authKeyFile = "/run/secrets/tailscale_key";
    # };
    # # Photoprism
    # services.photoprism = {
    #   enable = true;
    #   port = 2342;
    #   originalsPath = "/mnt/share/media/pictures";
    #   address = "0.0.0.0";
    #   settings = {
    #     PHOTOPRISM_ADMIN_USER = "admin";
    #     PHOTOPRISM_ADMIN_PASSWORD = "abcd_1234!";
    #     PHOTOPRISM_DEFAULT_LOCALE = "zh_CN";
    #     PHOTOPRISM_DATABASE_DRIVER = "mysql";
    #     PHOTOPRISM_DATABASE_NAME = "photoprism";
    #     PHOTOPRISM_DATABASE_SERVER = "/run/mysqld/mysqld.sock";
    #     PHOTOPRISM_DATABASE_USER = "photoprism";
    #   };
    # };
    # # MySQL
    # services.mysql = {
    #   enable = true;
    #   package = pkgs.mariadb;
    #   ensureDatabases = ["photoprism"];
    #   ensureUsers = [
    #     {
    #       name = "photoprism";
    #       ensurePermissions = {
    #         "photoprism.*" = "ALL PRIVILEGES";
    #       };
    #     }
    #   ];
    # };
  };
}
