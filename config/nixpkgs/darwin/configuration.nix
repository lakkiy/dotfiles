{ config, lib, pkgs, ... }:

{
  nix.binaryCaches = [ "https://mirrors.ustc.edu.cn/nix-channels/store" "https://cache.nixos.org/" ];
}
