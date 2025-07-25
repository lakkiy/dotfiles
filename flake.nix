{
  description = "Configurations of Lakkiy";

  inputs = {
    flake-utils.url = github:numtide/flake-utils;

    nixpkgs.url = github:NixOS/nixpkgs/nixos-25.05;
    home-manager = {
      url = github:nix-community/home-manager/release-25.05;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = github:NixOS/nixos-hardware;
    ags = {
      url = github:Aylur/ags;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    telega-overlay = {
      url = "github:ipvych/telega-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin-nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    darwin-nix-darwin = {
      url = github:LnL7/nix-darwin;
      inputs.nixpkgs.follows = "darwin-nixpkgs";
    };
    darwin-home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "darwin-nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    flake-utils,
    nixpkgs,
    home-manager,
    nixos-hardware,
    ags,
    zen-browser,
    telega-overlay,
    darwin-nixpkgs,
    darwin-nix-darwin,
    darwin-home-manager,
    ...
  }: let
    mkNixOS = user: hostName: specifiedModules:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit user hostName;
        };

        modules = [
          home-manager.nixosModules.home-manager
          ./modules/nixos-common.nix
          ./modules/nixos
          ./hosts/${hostName}.nix
          { nixpkgs.overlays = [ telega-overlay.overlay ]; }
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${user} = import ./home.nix;
              sharedModules = [ ags.homeManagerModules.default ];
            };
          }
        ] ++ specifiedModules;
      };

    mkDarwin = user: hostName: specifiedModules:
      darwin-nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";

        specialArgs = {
          inherit user hostName;
        };

        modules = [
          darwin-home-manager.darwinModules.home-manager
          ./modules/darwin-common.nix
          ./hosts/${hostName}.nix
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${user} = import ./home.nix;
            };
          }
        ] ++ specifiedModules;
      };
  in
    flake-utils.lib.eachDefaultSystem (system: {
      formatter = nixpkgs.legacyPackages.${system}.alejandra;
    })
    // {
      nixosConfigurations = {
        north = mkNixOS "lakkiy" "north" [
          {
            environment.systemPackages = [
              zen-browser.packages."x86_64-linux".default
            ];
          }
        ];
        homelab = mkNixOS "root" "homelab" [];
      };
      darwinConfigurations = {
        m3air = mkDarwin "liubo" "m3air" [];
        macmini = mkDarwin "lakki" "macmini" [];
      };
    };

  nixConfig = {
    accept-flake-config = true;
    experimental-features = ["nix-command" "flakes"];
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
