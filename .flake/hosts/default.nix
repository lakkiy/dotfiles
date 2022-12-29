{ lib, inputs, system, home-manager, user, ... }:

{
  nixos = lib.nixosSystem { # x1carbon gen8 nixos profile
    inherit system;
    specialArgs = { inherit user inputs; };
    modules = [
      ./nixos
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user; }; # pass flake variable
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] ++ [(import ./nixos/home.nix)];
        };
      }
    ];
  };

  wsl = lib.nixosSystem {}; # TODO
}
