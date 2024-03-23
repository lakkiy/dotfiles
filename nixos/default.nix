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
      ./nvidia.nix
      ./fcitx5.nix
      ./vsftpd.nix
      ./hyprland.nix
      # ./gnome.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.gray = {
          imports = [(import ./home.nix)] ++
                    [(import ./north/home.nix)] ++
                    [
                      (import ../home-manager/programming.nix)
                      (import ../home-manager/fonts.nix)
                      (import ../home-manager/fcitx5.nix)
                      (import ../home-manager/emacs.nix)
                      (import ../home-manager/gtk.nix)
                      (import ../home-manager/browser.nix)
                      (import ../home-manager/hyprland.nix)
                      # (import ../home-manager/gnome.nix)
                    ];
        };
      }
    ];
  };

  homelab = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs pkgs; };
    modules = [
      ./configuration.nix
      ./homelab

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.root = {
          imports = [(import ./home.nix)] ++ [(import ./homelab/home.nix)];
        };
      }
    ];
  };
}
