{ config, pkgs, ...}:

{
  home.packages = with pkgs; [
    gnome.gnome-tweaks
    gnomeExtensions.blur-my-shell
    gnomeExtensions.appindicator
    gnomeExtensions.gsconnect
    gnomeExtensions.caffeine
    gnomeExtensions.pop-shell
  ];

  dconf.settings = {
    "/org/gnome/desktop/interface/gtk-key-theme" = "Emacs";

    "/org/gnome/shell/enabled-extensions" = [
      "appindicatorsupport@rgcjonas.gmail.com"
      "caffeine@patapon.info"
      "gsconnect@andyholmes.github.io"
      "pop-shell@system76.com"
      "drive-menu@gnome-shell-extensions.gcampax.github.com"
      "user-theme@gnome-shell-extensions.gcampax.github.com"
      "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
      "blur-my-shell@aunetx"
    ];

    "/org/gnome/desktop/peripherals/touchpad/tap-to-click" = true;

    "/org/gnome/desktop/a11y/always-show-universal-access-status" = true

    "/org/gnome/desktop/input-sources/per-window" = true;

    "/org/gnome/desktop/wm/keybindings/switch-to-workspace-1" = "@as []";
    "/org/gnome/desktop/wm/keybindings/switch-to-workspace-1" = "['<Super>1']";
    "/org/gnome/shell/keybindings/switch-to-application-1" = "@as []";

    "/org/gnome/desktop/wm/keybindings/switch-to-workspace-2" = "@as []";
    "/org/gnome/desktop/wm/keybindings/switch-to-workspace-2" = "['<Super>2']";
    "/org/gnome/shell/keybindings/switch-to-application-2" = "@as []";

    "/org/gnome/desktop/wm/keybindings/switch-to-workspace-3" = "@as []";
    "/org/gnome/desktop/wm/keybindings/switch-to-workspace-3" = "['<Super>3']";
    "/org/gnome/shell/keybindings/switch-to-application-3" = "@as []";

    "/org/gnome/desktop/wm/keybindings/switch-to-workspace-4" = "@as []";
    "/org/gnome/desktop/wm/keybindings/switch-to-workspace-4" = "['<Super>4']";
    "/org/gnome/shell/keybindings/switch-to-application-4" = "@as []";
  };

  # gtk = {
  #   enable = true;

  #   iconTheme = {
  #     name = "Papirus-Dark";
  #     package = pkgs.papirus-icon-theme;
  #   };

  #   theme = {
  #     name = "palenight";
  #     package = pkgs.palenight-theme;
  #   };

  #   cursorTheme = {
  #     name = "Numix-Cursor";
  #     package = pkgs.numix-cursor-theme;
  #   };

  #   gtk3.extraConfig = {
  #     Settings = ''
  #       gtk-application-prefer-dark-theme=1
  #     '';
  #   };

  #   gtk4.extraConfig = {
  #     Settings = ''
  #       gtk-application-prefer-dark-theme=1
  #     '';
  #   };
  # };
  # home.sessionVariables.GTK_THEME = "palenight";
}
