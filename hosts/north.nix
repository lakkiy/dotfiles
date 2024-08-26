{
  nixpkgs,
  system,
  hostName,
  user,
}: {
  root = {
    imports = [
      "${nixpkgs}/nixos/modules/installer/scan/not-detected.nix"
    ];

    boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "uas" "sd_mod"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-amd"];
    boot.extraModulePackages = [];

    fileSystems."/" = {
      device = "/dev/disk/by-uuid/cf69bdf1-74bf-44ef-b9c5-9ca59cefdd10";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-uuid/0E46-2DBB";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    fileSystems."/mnt/share" = {
      device = "//192.168.31.203/share";
      fsType = "cifs";
      options = let
        # this line prevents hanging on network split
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        username = "share";
        password = "share";
      in ["${automount_opts},username=${username},password=${password},uid=1000,gid=100"];
    };

    swapDevices = [
      {device = "/dev/disk/by-uuid/fd8b2ba7-38bf-44fb-9c90-3baa42d8bd4a";}
    ];
  };

  module = {
    pkgs,
    config,
    lib,
    ...
  }: {
    imports = [];

    # For dual boot must disable windows's hibernate
    services.logind.powerKey = "hibernate";

    my.nvidia.enable = true;
    my.rime.enable = true;
    my.hyprland.enable = true;
    my.game.enable = true;
    my.virt.enable = true;
    home-manager.users.${user} = {
      my.syncthing.enable = true;
      my.emacs.enable = true;
      my.dev.enable = true;
      my.firefox.enable = true;
      my.font.enable = true;
      my.foot.enable = true;
      # TODO wallpaper engine
      home.file."Pictures/wallpapers".source = ../static/wallpapers;
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${user} = {
      isNormalUser = true;
      description = "Mr. Unhappy";
      extraGroups = ["networkmanager" "wheel"];
      packages = with pkgs; [
        firefox
        mpv
        obs-studio
        remmina # vnc viewer

        # open source dropbox cli and gui
        # can't use dropbox since it can't login
        maestral
        maestral-gui

        localsend
        xdg-user-dirs

        zotero
        blender
        gimp
        inkscape
        xournalpp
        filezilla
        nautilus # file manager
      ];
    };

    system.stateVersion = "24.05";
    networking.useDHCP = lib.mkDefault true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

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
        allowedUDPPorts = [53317];
      };
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Pipewire && Bluetooth
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
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

    services.xserver = {
      enable = true;
      # Set keyboard repat, rate = 60
      autoRepeatInterval = 60;
      autoRepeatDelay = 120;
      xkb.layout = "us";
      xkb.variant = "dvorak";
    };
  };
}
