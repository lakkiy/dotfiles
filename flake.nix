{
  description = "A very basic flake";


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

    gotraceui.url = "github:dominikh/gotraceui";
    ags.url = "github:Aylur/ags";
    daeuniverse.url = "github:daeuniverse/flake.nix";
  };


  outputs = inputs @ { self, nixpkgs, home-manager, darwin, ... }:
    {
      nixosConfigurations = ( # NixOS configurations
        import ./nixos {
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

      homeConfigurations = ( # Non-NixOS configurations
        import ./home-manager {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager;
        }
      );
    };


  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
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
    trusted-users = [ "root" "liubo" "gray" ];
  };
}
