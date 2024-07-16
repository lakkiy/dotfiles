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

  outputs = inputs @ {self, nixpkgs, nixpkgs-unstable, home-manager, darwin, ...}:
    let
      vars = {
        user = "mrunhap";
      };
    in
      {
        nixosConfigurations = (
          import ./systems/nixos {
            inherit (nixpkgs) lib;
            inherit inputs nixpkgs nixpkgs-unstable home-manager vars;
          }
        );

        homeConfigurations = ( # Non-NixOS configurations
          import ./systems/nonnixos {
            inherit (nixpkgs) lib;
            inherit inputs nixpkgs nixpkgs-unstable home-manager vars;
          }
        );

        darwinConfigurations = ( # Darwin configurations
          import ./systems/darwin {
            inherit (nixpkgs) lib;
            inherit inputs nixpkgs nixpkgs-unstable home-manager darwin vars;
          }
        );
      };

  nixConfig = {
    experimental-features = ["nix-command" "flakes"];
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
