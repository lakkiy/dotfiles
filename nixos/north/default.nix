# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "north";
    networkmanager.enable = true;
    defaultGateway = "192.168.31.222";
    nameservers = ["192.168.31.222"];
    interfaces.wlp9s0.ipv4.addresses = [
      {
        address = "192.168.31.41";
        prefixLength = 24;
      }
    ];
    firewall = {
      enable = true;
      allowedTCPPorts = [
        # localsend
        53317
        # vsftpd
        2121
      ];
      allowedUDPPorts = [53317];
    };
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

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
      mpv
      plex-media-player
      qbittorrent
      obs-studio
      ventoy # bootable usb
      cider # apple music client
      localsend
      xdg-user-dirs # send/recv file to phone
      inkscape # Vector graphics editor
      fractal # matrix client
      qq
      discord
      goldendict-ng
      filezilla # ftp ftps sftp gui client
      spacedrive
      xournalpp

      # open source dropbox cli and gui
      # can't use dropbox since it can't login
      maestral maestral-gui
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

  system.stateVersion = "23.11";
}
