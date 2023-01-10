{ config, pkgs, ...}:

{
  home.packages = with pkgs; [
    v2ray
    v2ray-geoip
    v2ray-domain-list-community
    clash
  ];
}
