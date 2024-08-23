{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.syncthing;
in {
  options.my.syncthing = {
    enable = mkEnableOption "syncthing";
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      extraOptions = [
        "--no-default-folder"
        "--gui-address=http://127.0.0.1:8384"
      ];
    };
  };
}
