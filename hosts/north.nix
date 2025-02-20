{
  nixpkgs,
  system,
  hostName,
  user,
}: {
  module = {
    pkgs,
    config,
    lib,
    ...
  }: {
    imports = [];

    users.users.${user} = {
      isNormalUser = true;
      description = "";
      extraGroups = ["networkmanager" "wheel"];
      packages = with pkgs; [
        nautilus                # file manager
        mpv                     # video player
        obs-studio              # streaming
        maestral maestral-gui   # open source dropbox
        localsend xdg-user-dirs # trans file and text between phone
        zotero                  # pdf
        filezilla               # ftp client
      ];
    };
    my = {
      hyprland.enable = true;
      inputMethod.enable = true;
      virt.enable = true;
      nvidia.enable = true;
      game.enable = true;
    };
    home-manager.users.${user}.my = {
      dev.enable = true;
      emacs.enable = true;
      font.enable = true;
      syncthing.enable = true;
      terminal.enable = true;
    };

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

    #-------------------------------------------------------------
    # For dual boot must disable windows's hibernate
    services.logind.powerKey = "hibernate";

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking = {
      hostName = "north";
      networkmanager.enable = true;
      firewall = {
        enable = true;
        allowedTCPPorts = [
          53317 # localsend
        ];
        allowedUDPPorts = [53317];
      };
    };

    services.printing.enable = true;
    services.xserver = {
      enable = true;
      autoRepeatInterval = 60;
      autoRepeatDelay = 120;
      xkb.layout = "us";
      xkb.variant = "dvorak";
    };

    networking.useDHCP = lib.mkDefault true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    system.stateVersion = "24.11";
    #-------------------------------------------------------------
  };

  root = {
    imports = [
      "${nixpkgs}/nixos/modules/installer/scan/not-detected.nix"
    ];

    boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "uas" "sd_mod"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-amd"];
    boot.extraModulePackages = [];

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
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
      {device = "/dev/disk/by-label/swap";}
    ];
  };
}
