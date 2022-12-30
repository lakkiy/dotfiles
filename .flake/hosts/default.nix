{ lib, inputs, nixpkgs, home-manager, ... }:

let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{
  x1carbon = lib.nixosSystem { # x1carbon gen8 nixos profile
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ./x1carbon
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.swim = {
          imports = [(import ./home.nix)] ++ [(import ./x1carbon/home.nix)];
        };
      }
    ];
  };

  esxi-nixos = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ./esxi-nixos
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.root = {
          imports = [(import ./home.nix)] ++ [(import ./esxi-nixos/home.nix)];
        };
      }
    ];
  };
}
