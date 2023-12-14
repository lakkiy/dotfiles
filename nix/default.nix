{ lib, inputs, nixpkgs, home-manager, nur, ... }:

let
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    config.permittedInsecurePackages = [
      # wechat-uos
      # https://github.com/nix-community/nur-combined/blob/master/repos/xddxdd/pkgs/uncategorized/wechat-uos/official-bin.nix#L23
      "openssl-1.1.1w"
    ];
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
      nur.hmModules.nur
      ./home.nix
      ./pacman.nix
      {
        home.username = "liubo";
        home.homeDirectory = "/home/liubo";
      }
    ];
  };
}
