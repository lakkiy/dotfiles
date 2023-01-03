{ config, pkgs, inputs, ... }:

{
  imports = [
    (import ../modules/programming.nix)
    (import ../modules/terminal.nix)
    # (import ../modules/emacs.nix);
  ];

  programs = {
    ssh.enable = true;
  };

  home.packages = with pkgs; [
  ];

  nix = {                                               # Nix Package Manager settings
    settings ={
      auto-optimise-store = true;                       # Optimise syslinks
      experimental-features = [ "nix-command" "flakes" ];
    };
    package = pkgs.nixFlakes;                           # Enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
  };
  nixpkgs.config.allowUnfree = true;                    # Allow proprietary software.
  # https://github.com/nix-community/home-manager/issues/2942#issuecomment-1119760100
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
}
