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

    nur.url = "github:nix-community/NUR";
    gotraceui.url = "github:dominikh/gotraceui";
    ags.url = "github:Aylur/ags";
    hyprland.url = "github:hyprwm/Hyprland";
    daeuniverse.url = "github:daeuniverse/flake.nix";
  };


  outputs = inputs @ { self, nixpkgs, home-manager, darwin, nur, ... }:
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
          inherit inputs nixpkgs home-manager nur;
        }
      );
    };


  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org/"
      "https://hyprland.cachix.org"
      "https://xddxdd.cachix.org" # wechat-uos in nur
    ];
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "xddxdd.cachix.org-1:ay1HJyNDYmlSwj5NXQG065C8LfoqqKaTNCyzeixGjf8="
    ];
    trusted-users = [ "root" "liubo" "gray" ];
  };
}
