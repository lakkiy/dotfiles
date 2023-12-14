{ config, pkgs, inputs, ... }:

{
  programs = {
    home-manager.enable = true;
    bash.enable = true;
  };

  home.stateVersion = "23.05";
  targets.genericLinux.enable = true;

  nix = {                                               # Nix Package Manager settings
    settings ={
      auto-optimise-store = true;                       # Optimise syslinks
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "liubo" "gray" ];
    };
    package = pkgs.nixFlakes;                           # Enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
  };
  nixpkgs.config.allowUnfree = true;                    # Allow proprietary software.
  # https://github.com/nix-community/home-manager/issues/2942#issuecomment-1119760100
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
}
