{ lib, inputs, nixpkgs, nixpkgs-unstable, home-manager, darwin, ... }:

let
  systemConfig = system: {
    system = system;
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    upkgs = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  };
in {
  mac =
    let
      inherit (systemConfig "x86_64-darwin") system pkgs upkgs;
    in
      darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit inputs system pkgs upkgs; };
        modules = [
          ./configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.liubo = import ./home.nix;
            home-manager.extraSpecialArgs.upkgs = upkgs;
          }
        ];
      };
}
