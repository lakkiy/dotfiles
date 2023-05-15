{ lib, inputs, nixpkgs, home-manager, darwin, ... }:

let
  system = "x86_64-darwin";
in
{
  mac = darwin.lib.darwinSystem {
    inherit system;
    specialArgs = { inherit inputs; };
    modules = [
      ./configuration.nix

      home-manager.darwinModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.liubo = import ./home.nix;
      }
    ];
  };
}
