{lib, inputs, outputs, nixpkgs, home-manager, ...}:
let
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
      ./north
      ./nvidia
      ./fcitx5
      ./vsftpd
      ./desktop/hyprland.nix
      ./game
      # ./proxy
      ./virt

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        # see https://github.com/gmodena/nix-flatpak#notes-on-homemanager
        home-manager.extraSpecialArgs.flake-inputs = inputs;
        home-manager.users.mrunhap = {
          imports = [ ./north/home.nix ];
          programs.home-manager.enable = true;
          home.username = "mrunhap";
          home.homeDirectory = "/home/mrunhap";
          home.stateVersion = "23.11";
        };
      }
    ];
  };

  homelab = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs outputs pkgs; };
    modules = [
      ./homelab

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs.flake-inputs = inputs;
        home-manager.users.root = {
          programs.home-manager.enable = true;
          home.username = "root";
          home.homeDirectory = "/root";
          home.stateVersion = "23.11";
        };
      }
    ];
  };
}
