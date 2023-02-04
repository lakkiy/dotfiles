{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;

  networking = {
    hostName = "esxi-nixos";
    networkmanager.enable = true;
    defaultGateway = "192.168.31.222";
    nameservers = [ "192.168.31.222" ];
    interfaces.ens33.ipv4.addresses = [{
      address = "192.168.31.102";
      prefixLength = 24;
    }];
  };

  console.keyMap = "dvorak";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  # bitwarden, qbittorrent
  services = {
    freshrss = {
      enable = false;
    };
    plex = {
      enable = false;
    };
    syncthing = {
      enable = false;
    };
    cloudflared = {
      enable = false;
    };
  };

  # Change default shell to zsh.
  # https://nixos.wiki/wiki/Command_Shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Enable the OpenSSH daemon.
  services.openssh.permitRootLogin = "yes";
}
