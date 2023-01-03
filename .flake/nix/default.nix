{ lib, inputs, nixpkgs, home-manager, ... }:

let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
in
{
  server = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = { inherit inputs; };
    modules = [
      ./server.nix
      {
        home = {
          username = "root";
          homeDirectory = "/root";
          packages = [ pkgs.home-manager ];
          stateVersion = "22.05";
        };
      }
    ];
  };
}
