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
    mkHost = user: hostName: system: specifiedModules: let
      specifics = {
        nixpkgs = nixpkgs;
        nixSystem = nixpkgs.lib.nixosSystem;
        modules = [
          home-manager.nixosModules.home-manager
          ./modules/nixos-common.nix
          ./modules/nixos
          {nixpkgs.overlays = [ telega-overlay.overlay ];}
        ];
        hm-modules = [
          ags.homeManagerModules.default
        ];
      };
    in let
      hostConfig = import ./hosts/${hostName}.nix {
        inherit (specifics) nixpkgs;
        inherit system hostName user;
      };
      lib = specifics.nixpkgs.lib.extend (final: prev: {
        # …
      });
      hostRootModule =
        {
          system.configurationRevision =
            if (self ? rev)
            then self.rev
            else throw "refuse to build: git tree is dirty";
        }
        // hostConfig.root;
      homeManagerModules = [
        ({config, ...}: {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${user} = import ./home.nix;
            sharedModules = specifics.hm-modules;
            extraSpecialArgs = {
              isDarwin = false;
            };
          };
        })
      ];
    in
      specifics.nixSystem {
        inherit system;

        specialArgs = {
          inherit (specifics) nixpkgs;
          isDarwin = false;
          inherit hostName lib user;
        };

        modules =
          [
            ./common.nix
          ]
          ++ specifics.modules
          ++ [
            hostRootModule
            hostConfig.module
          ]
          ++ homeManagerModules
          ++ specifiedModules;
      };

    mkDarwin = user: hostName: specifiedModules:
      darwin-nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";

        specialArgs = {
          inherit user hostName;
        };

        modules =
          [
            darwin-home-manager.darwinModules.home-manager
            ./modules/darwin-common.nix
            ./hosts/${hostName}.nix
            ({config, ...}: {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.${user} = import ./home.nix;
                # TODO remove this from darwin
                sharedModules = [ ags.homeManagerModules.default ];
              };
            })
          ]
          ++ specifiedModules;
      };
  in
    flake-utils.lib.eachDefaultSystem (system: {
      formatter = nixpkgs.legacyPackages.${system}.alejandra;
    })
    // {
      nixosConfigurations = {
        north = mkHost "lakkiy" "north" "x86_64-linux" [
          {
            environment.systemPackages = [
              zen-browser.packages."x86_64-linux".default
            ];
          }
        ];
        homelab = mkHost "root" "homelab" "x86_64-linux" [];
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
