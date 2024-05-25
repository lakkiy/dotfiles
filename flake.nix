{
  description = "Configurations of Mr.Unhappy";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags.url = "github:Aylur/ags";
    gotraceui.url = "github:dominikh/gotraceui";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    darwin,
    ...
  }: let
    inherit (self) outputs;
    # Variables Used In Flake.
    vars = {
      user = "mrunhap";
    };
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    overlays = import ./overlays {inherit inputs;};
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#{$HOST}'
    nixosConfigurations = (
      import ./hosts {
        inherit (nixpkgs) lib;
        inherit inputs outputs nixpkgs home-manager;
      }
    );

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#{$USER}@{$HOST}'
    homeConfigurations = ( # Non-NixOS configurations
      import ./home-manager {
        inherit (nixpkgs) lib;
        inherit inputs outputs nixpkgs home-manager;
      }
    );

    # Standalone darwin configuration entrypoint (macOS)
    # Available through 'darwin-rebuild --flake .#{$HOST}'
    darwinConfigurations = ( # Darwin configurations
      import ./darwin {
        inherit (nixpkgs) lib;
        inherit inputs outputs nixpkgs home-manager darwin;
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
