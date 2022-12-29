{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, darwin, ... }:
    let
      user = "swim";
    in {
      # nixos-rebuild switch --flake .#
      nixosConfigurations = ( # NixOS configurations
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager user;
        }
      );

      darwinConfigurations = ( # Darwin configurations
        import ./darwin {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager darwin user;
        }
      );

      homeConfigurations = ( # Non-NixOS configurations
        import ./nix {
          inherit (nixpkgs) lib;
          ihherit inputs nixpkgs home-manager user;
        }
      );
    };
}
