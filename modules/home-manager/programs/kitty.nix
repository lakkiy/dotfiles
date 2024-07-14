{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.my.kitty;

in {
  options.my.kitty = {
    enable = mkEnableOption "kitty";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
    };
  };
}
