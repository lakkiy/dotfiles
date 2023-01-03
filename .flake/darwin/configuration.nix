{ config, pkgs, ... }:

{
  services.nix-daemon.enable = true;
  nix = {
    package = pkgs.nix;
    settings ={
      auto-optimise-store = true;           # Optimise syslinks
      experimental-features = [ "nix-command" "flakes" ];
    };
    gc = {                                # Garbage collection
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
  };
}
