{ lib, inputs, nixpkgs, home-manager, user, ... }:

let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
in
{
}
