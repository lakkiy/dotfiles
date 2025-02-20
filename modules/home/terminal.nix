{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.terminal;
in {
  options.my.terminal = {
    enable = mkEnableOption "GUI Terminal for System";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
    };
  };
}
