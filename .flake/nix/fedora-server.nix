{ config, pkgs, inputs, user, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs = {
    home-manager.enable = true;
  };

  home.packages = with pkgs; [
    ripgrep
  ];
}
