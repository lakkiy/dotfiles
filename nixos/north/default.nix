{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../modules/nixos/nvidia.nix
      ../../modules/nixos/fcitx5.nix
      # ../../modules/nixos/gnome.nix
      ../../modules/nixos/hyprland.nix
      ../../modules/nixos/browser.nix
      ../../modules/nixos/vsftpd.nix
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

  # Bluetooth
  services.pipewire.wireplumber.configPackages = [
	  (pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
  		bluez_monitor.properties = {
  			["bluez5.enable-sbc-xq"] = true,
  			["bluez5.enable-msbc"] = true,
  			["bluez5.enable-hw-volume"] = true,
  			["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
  		}
	  '')
  ];
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # For dual boot must disable windows's hibernate
  services.logind.powerKey = "hibernate";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gray = {
    isNormalUser = true;
    description = "gray";
    extraGroups = [ "docker" "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [
      mpv
      plex-media-player
      qbittorrent
      obs-studio
      dropbox
      ventoy # bootable usb
      cider # apple music client
      localsend xdg-user-dirs # send/recv file to phone
      inkscape # Vector graphics editor
      fractal # matrix client
      qq
      discord
      goldendict-ng
      filezilla # ftp ftps sftp gui client
    ];
  };

  # for fractal
  services.gnome.gnome-keyring.enable = true;

  # mount nas smb share dir
  fileSystems."/mnt/share" = {
    device = "//192.168.31.61/share";
    fsType = "cifs";
    options = let
      # this line prevents hanging on network split
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

      # username=<USERNAME>
      # domain=<DOMAIN>
      # password=<PASSWORD>
    in ["${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100"];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  services.dae = {
    enable = true;
    # make sure to create the config file
    # global{}
    # routing{}
    configFile = "/etc/dae/config.dae";
  };

  # wayland support for electron base app
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  system.stateVersion = "23.11";
}
