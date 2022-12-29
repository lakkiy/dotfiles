{ lib, inputs, nixpkgs, home-manager, user, ... }:

let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
  user = "liubo"; # Just for current already insatlled system.
in
{
  fedora-server = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = { inherit inputs user; };
    modules = [
      ./fedora-server.nix
      {
        home = {
          username = "${user}";
          homeDirectory = "/home/${user}";
          packages = [ pkgs.home-manager ];
          stateVersion = "22.05";
        };
      }
    ];
  };
}
