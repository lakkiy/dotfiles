{
  description = "Configurations of Mr.Unhappy";

  inputs = {
    flake-utils.url = github:numtide/flake-utils;

    unstable-nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;
    unstable-home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "unstable-nixpkgs";
    };
    unstable-nixos-hardware.url = github:NixOS/nixos-hardware;
    ags = {
      url = github:Aylur/ags;
      inputs.nixpkgs.follows = "unstable-nixpkgs";
    };
    zen-browser = {
      url = "github:MarceColl/zen-browser-flake";
      inputs.nixpkgs.follows = "unstable-nixpkgs";
    };

    darwin-nixpkgs.url = github:NixOS/nixpkgs/nixpkgs-24.05-darwin;
    darwin-nix-darwin = {
      url = github:LnL7/nix-darwin/master;
      inputs.nixpkgs.follows = "darwin-nixpkgs";
    };
    darwin-home-manager = {
      url = github:nix-community/home-manager/release-24.05;
      inputs.nixpkgs.follows = "darwin-nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    flake-utils,
    unstable-nixpkgs,
    unstable-home-manager,
    unstable-nixos-hardware,
    ags,
    zen-browser,
    darwin-nixpkgs,
    darwin-nix-darwin,
    darwin-home-manager,
    ...
  }: let
    mkHome = user: hostName: system: specifiedModules:
      unstable-home-manager.lib.homeManagerConfiguration {
        inherit (import unstable-nixpkgs { inherit system; }) pkgs;
        modules = [
          ags.homeManagerModules.default
          ./home.nix
          ./hosts/${hostName}.nix
        ];
    };
    mkHost = user: hostName: system: specifiedModules: let
      isDarwin = builtins.elem system unstable-nixpkgs.lib.platforms.darwin;
      specifics =
        {
          nixos = {
            nixpkgs = unstable-nixpkgs;
            nixSystem = unstable-nixpkgs.lib.nixosSystem;
            modules = [
              unstable-home-manager.nixosModules.home-manager
              ./modules/nixos-common.nix
              ./modules/nixos
            ];
            hm-modules = [
              ags.homeManagerModules.default
            ];
          };
          darwin = {
            nixpkgs = darwin-nixpkgs;
            nixSystem = darwin-nix-darwin.lib.darwinSystem;
            modules = [
              darwin-home-manager.darwinModules.home-manager
              ./modules/darwin-common.nix
            ];
            hm-modules = [
              ags.homeManagerModules.default
            ];
          };
        }
        .${
          if isDarwin
          then "darwin"
          else "nixos"
        };
    in let
      hostConfig = import ./hosts/${hostName}.nix {
        inherit (specifics) nixpkgs;
        inherit system hostName user;
      };
      lib = specifics.nixpkgs.lib.extend (final: prev: {
        # …
      });
      freezeRegistry = {
        nix.registry = lib.mapAttrs (_: flake: {inherit flake;}) inputs;
      };
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
              inherit isDarwin;
            };
          };
        })
      ];
    in
      specifics.nixSystem {
        inherit system;

        specialArgs = {
          inherit (specifics) nixpkgs;
          inherit isDarwin hostName lib user;
        };

        modules =
          [
            ./common.nix
            freezeRegistry
          ]
          ++ specifics.modules
          ++ [
            hostRootModule
            hostConfig.module
          ]
          ++ homeManagerModules
          ++ specifiedModules;
      };
  in
    flake-utils.lib.eachDefaultSystem (system: {
      formatter = unstable-nixpkgs.legacyPackages.${system}.alejandra;
    })
    // {
      nixosConfigurations = {
        north = mkHost "mrunhap" "north" "x86_64-linux" [
          {
            environment.systemPackages = [zen-browser.packages."x86_64-linux".default];
          }
        ];
        homelab = mkHost "root" "homelab" "x86_64-linux" [];
      };
      darwinConfigurations = {
        cmcm = mkHost "mrunhap" "cmcm" "x86_64-darwin" [];
        macmini = mkHost "liubo" "macmini" "aarch64-darwin" [];
      };
      homeConfigurations = {
        server = mkHome "root" "server" "x86_64-linux" [];
      };
    };

  nixConfig = {
    accept-flake-config = true;
    experimental-features = ["nix-command" "flakes" "repl-flake"];
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
