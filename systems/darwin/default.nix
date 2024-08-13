{ lib, inputs, nixpkgs, nixpkgs-unstable, home-manager, darwin, vars, ... }:

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
  cmcm =
    let
      inherit (systemConfig "x86_64-darwin") system pkgs upkgs;
    in
      darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit inputs system pkgs upkgs vars; };
        modules = [
          ./configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs.upkgs = upkgs;
            home-manager.extraSpecialArgs.flake-inputs = inputs;
            home-manager.users.${vars.user} = import ./home.nix;
          }
        ];
      };
}
