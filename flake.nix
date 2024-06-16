{
  description = "Configurations of Mr.Unhappy";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {self, nixpkgs, nixpkgs-unstable, home-manager, darwin, ...}: {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#{$HOST}'
    nixosConfigurations = (
      import ./systems/nixos {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs nixpkgs-unstable home-manager;
      }
    );

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#{$USER}@{$HOST}'
    homeConfigurations = ( # Non-NixOS configurations
      import ./systems/nonnixos {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs nixpkgs-unstable home-manager;
      }
    );

    # Standalone darwin configuration entrypoint (macOS)
    # Available through 'darwin-rebuild --flake .#{$HOST}'
    darwinConfigurations = ( # Darwin configurations
      import ./systems/darwin {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs nixpkgs-unstable home-manager darwin;
      }
    );
  };

  nixConfig = {
    experimental-features = ["nix-command" "flakes"];
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
    ];
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    trusted-users = ["root" "liubo" "mrunhap"];
  };
}
