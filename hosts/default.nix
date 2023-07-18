{ lib, inputs, nixpkgs, home-manager, emacs-overlay, ... }:

let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    overlays = [ emacs-overlay.overlay ];
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{
  north = lib.nixosSystem {
    inherit system;
    inherit pkgs;
    specialArgs = { inherit inputs pkgs; };
    modules = [
      ./configuration.nix
      ./north

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.gray = {
          imports = [(import ./home.nix)] ++ [(import ./north/home.nix)];
        };
      }
    ];
  };

  x1carbon = lib.nixosSystem {
    inherit system;
    inherit pkgs;
    specialArgs = { inherit inputs pkgs; };
    modules = [
      ./configuration.nix
      ./x1carbon

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.gray = {
          imports = [(import ./home.nix)] ++ [(import ./x1carbon/home.nix)];
        };
      }
    ];
  };

  server = lib.nixosSystem {
    inherit system;
    inherit pkgs;
    specialArgs = { inherit inputs; };
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
