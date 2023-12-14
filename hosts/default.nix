{ lib, inputs, nixpkgs, home-manager, ... }:

let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  } // {
    ags = inputs.ags.packages.${system}.default;
  };

  lib = nixpkgs.lib;
in
{
  north = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs pkgs; };
    modules = [
      ./configuration.nix
      ./north
      inputs.daeuniverse.nixosModules.dae
      inputs.daeuniverse.nixosModules.daed

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.gray = {
          imports = [(import ./home.nix)] ++ [(import ./north/home.nix)];
        };
      }
    ];
  };

  server = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs pkgs; };
    modules = [
      ./configuration.nix
      ./server

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.root = {
          imports = [(import ./home.nix)] ++ [(import ./server/home.nix)];
        };
      }
    ];
  };
}
