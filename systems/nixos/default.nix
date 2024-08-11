{ inputs, nixpkgs, nixpkgs-unstable, home-manager, ...}:
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

  lib = nixpkgs.lib;
in {
  north = lib.nixosSystem {
    inherit system;
    specialArgs = {inherit inputs pkgs upkgs;};
    modules = [
      ./north
      ../../modules/nixos
      {
        my.nvidia.enable = true;
        my.fcitx5.enable = true;
        my.wm.hyprland.enable = true;
        my.game.enable = true;
        my.virt.enable = true;
      }
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        # see https://github.com/gmodena/nix-flatpak#notes-on-homemanager
        home-manager.extraSpecialArgs.flake-inputs = inputs;
        home-manager.extraSpecialArgs.upkgs = upkgs;
        home-manager.users.mrunhap = {
          imports = [ ../../modules/home-manager ];
          programs.home-manager.enable = true;
          home.username = "mrunhap";
          home.homeDirectory = "/home/mrunhap";
          home.stateVersion = "24.05";

          my.shell.enable = true;
          my.services.syncthing.enable = true;
          my.emacs.enable = true;
          my.dev.enable = true;
          my.chromium.enable = true;
          my.firefox.enable = true;
          my.font.enable = true;
          my.foot.enable = true;
          home.file."Pictures/wallpapers".source = ../../static/wallpapers;
        };
      }
    ];
  };

  homelab = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs pkgs; };
    modules = [
      ./homelab

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs.flake-inputs = inputs;
        home-manager.users.root = {
          programs.home-manager.enable = true;
          home.username = "root";
          home.homeDirectory = "/root";
          home.stateVersion = "24.05";
        };
      }
    ];
  };
}
