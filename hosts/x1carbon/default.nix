{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  networking = {
    hostName = "x1carbon";
    networkmanager.enable = true;
    defaultGateway = "192.168.31.222";
    nameservers = [ "192.168.31.222" ];
    interfaces.wlan0.ipv4.addresses = [{
      address = "192.168.31.150";
      prefixLength = 24;
    }];
  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.utf8";
    LC_IDENTIFICATION = "zh_CN.utf8";
    LC_MEASUREMENT = "zh_CN.utf8";
    LC_MONETARY = "zh_CN.utf8";
    LC_NAME = "zh_CN.utf8";
    LC_NUMERIC = "zh_CN.utf8";
    LC_PAPER = "zh_CN.utf8";
    LC_TELEPHONE = "zh_CN.utf8";
    LC_TIME = "zh_CN.utf8";
  };

  # Enable the X11 windowing system.
  services = {
    xserver = {
      enable = true;
      # GNOME
      displayManager = {
        gdm.enable = true; # FOR GNOME
#        lightdm.enable = true;
#	defaultSession = "xfce"; # FOR XFCE
      };
      desktopManager = {
        gnome.enable = true; # GNOME
#	xterm.enable = false;
#	xfce.enable = true;
      };
    };
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "dvorak";
    xkbOptions = "ctrl:swapcaps";
  };

  # Configure console keymap
  #console.keyMap = "dvorak";
  console.useXkbConfig = true;

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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.gray = {
    isNormalUser = true;
    description = "gray";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # For sound
    fwupd
    sof-firmware
  ];
}
