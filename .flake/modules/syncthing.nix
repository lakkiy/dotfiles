{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    extraOptions = [
      "--no-default-folder"
      "--gui-address=http://0.0.0.0:8384"
    ];
  };
}
