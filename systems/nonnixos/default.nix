{ lib, inputs, nixpkgs, nixpkgs-unstable, home-manager, ... }:

let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  upkgs = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  server = home-manager.lib.homeManagerConfiguration {
    inherit (nixpkgs) lib;
    inherit pkgs;
    extraSpecialArgs = {inherit inputs upkgs;};
    modules = [
      ./home.nix
      ../../modules/home-manager
      {
        home.username = "root";
        home.homeDirectory = "/root";
        my.emacs.enable = true;
        my.emacs.package = pkgs.emacs-nox;
        my.dev.enable = true;
        my.shell.enable = true;
        my.services.syncthing.enable = true;
      }
    ];
  };

  titan = home-manager.lib.homeManagerConfiguration {
    inherit (nixpkgs) lib;
    inherit pkgs;
    extraSpecialArgs = {inherit inputs upkgs;};
    modules = [
      ./home.nix
      ../../modules/home-manager
      {
        home.username = "liubo";
        home.homeDirectory = "/home/liubo";
        my.emacs.enable = true;
        my.emacs.package = pkgs.emacs;
        my.dev.enable = true;
        my.shell.enable = true;
        my.services.syncthing.enable = true;
      }
    ];
  };

  pacman = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {inherit inputs upkgs;};
    modules = [
      ./home.nix
      ../../modules/home-manager
      {
        home.username = "mrunhap";
        home.homeDirectory = "/home/mrunhap";
        my.dev.enable = true;
        my.shell.enable = true;
        my.services.syncthing.enable = true;
      }
    ];
  };

  virt = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    extraSpecialArgs = {inherit inputs upkgs;};
    modules = [
      ./home.nix
      ../../modules/home-manager
      {
        home.username = "mrunhap";
        home.homeDirectory = "/home/mrunhap";
        my.dev.enable = true;
        my.shell.enable = true;
      }
    ];
  };
}
