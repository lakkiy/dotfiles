{ lib, inputs, nixpkgs, home-manager, ... }:

let
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  server = home-manager.lib.homeManagerConfiguration {
    inherit (nixpkgs) lib;
    inherit pkgs;
    extraSpecialArgs = { inherit inputs; };
    modules = [
      ./home.nix
      ./server.nix
      {
        home.username = "root";
        home.homeDirectory = "/root";
      }
    ];
  };

  pacman = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = { inherit inputs; };
    modules = [
      ./home.nix
      ./pacman.nix
      {
        home.username = "liubo";
        home.homeDirectory = "/home/liubo";
      }
    ];
  };
}
