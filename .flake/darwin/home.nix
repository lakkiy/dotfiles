{ pkgs, ... }:

{
  home = {
    packages = [ pkgs.home-manager ];
    stateVersion = "22.11";
  };
}
