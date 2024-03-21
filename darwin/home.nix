# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix

    (import ../modules/tui.nix)
    (import ../modules/programming.nix)
  ];

  home = {
    packages = with pkgs; [
      home-manager
      coreutils
    ];
    stateVersion = "23.11";
  };

  home.file."Pictures/wallpapers".source = ../modules/files/wallpapers;
  home.file.".config/karabiner/karabiner.json".source = ../modules/files/karabiner.json;
}
