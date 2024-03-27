{
  lib,
  inputs,
  nixpkgs,
  home-manager,
  ...
}: let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in {
  north = lib.nixosSystem {
    inherit system;
    specialArgs = {inherit inputs pkgs;};
    modules = [
      ./configuration.nix
      ./north
      ./nvidia
      ./fcitx5
      ./vsftpd
      ./desktop/hyprland.nix
      ./game
      ./proxy
      ./virt

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.gray = {
          imports = [
            ./home.nix
            ../home-manager/browser
            ../home-manager/editor
            ../home-manager/font
            ../home-manager/develop
          ];
          home.username = "gray";
          home.homeDirectory = "/home/gray";
        };
      }
    ];
  };

  homelab = lib.nixosSystem {
    inherit system;
    specialArgs = {inherit inputs pkgs;};
    modules = [
      ./configuration.nix
      ./homelab

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.root = {
          imports = [ ./home.nix ];
          home.username = "root";
          home.homeDirectory = "/root";
        };
      }
    ];
  };
}
