{ config, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    extraOptions = [
      "--no-default-folder"
      "--gui-address=http://127.0.0.1:8384"
    ];
  };
}
