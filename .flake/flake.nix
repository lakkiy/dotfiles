{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = github:nix-community/emacs-overlay;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, darwin, emacs-overlay, ... }:
    {
      # nixos-rebuild switch --flake .#<host>
      nixosConfigurations = ( # NixOS configurations
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager;
        }
      );

      darwinConfigurations = ( # Darwin configurations
        import ./darwin {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager darwin;
        }
      );

      # For first time:
      # nix build --extra-experimental-features 'nix-command flakes' .#homeConfigurations.<host>.activationPackage
      # ./result/activate
      # Then:
      # home-manager switch --flake .#<host>
      homeConfigurations = ( # Non-NixOS configurations
        import ./nix {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager;
        }
      );
    };
}
