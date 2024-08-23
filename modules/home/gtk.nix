{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.gtk;
in {
  options.my.gtk = {
    enable = mkEnableOption "gtk";
  };

  config = mkIf cfg.enable {
    home.activation.removeExistingGtk = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
      rm -rf ~/.gtkrc-2.0
      rm -rf ~/.config/gtk-3.0
      rm -rf ~/.config/gtk-4.0
    '';

    gtk = {
      enable = true;

      font = {
        name = "Noto Sans";
        package = pkgs.noto-fonts;
        size = 11;
      };

      cursorTheme = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 32;
      };

      gtk3.extraConfig = {
        gtk_application_prefer_dark_theme = 1;
      };

      gtk4.extraConfig = {
        gtk_application_prefer_dark_theme = 1;
      };
    };
  };
}
