{ config, lib, ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  users.users.mrunhap.extraGroups = [ "docker" ];
}
