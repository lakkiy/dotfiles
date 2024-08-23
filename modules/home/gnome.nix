{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.gnome;
in {
  options.my.gnome = {
    enable = mkEnableOption "gnome";
  };

  config = mkIf cfg.enable {
    # with lib.hm.gvariant
    home.packages = with pkgs; [
      gnomeExtensions.appindicator
      gnomeExtensions.gsconnect
      gnomeExtensions.caffeine
      gnomeExtensions.blur-my-shell
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.shu-zhi
      gnomeExtensions.just-perfection
    ];

    dconf.settings = {
      "org/gnome/Console" = {
        font-scale = 1.2;
      };

      "org/gnome/desktop/a11y" = {
        always-show-universal-access-status = true;
      };

      "org/gnome/desktop/input-sources" = {
        per-window = true;
        sources = [(mkTuple ["xkb" "us+dvorak"])];
        xkb-options = ["terminate:ctrl_alt_bksp" "lv3:ralt_switch"];
      };

      "org/gnome/desktop/interface" = {
        clock-show-date = true;
        clock-show-seconds = true;
        clock-show-weekday = true;
        color-scheme = "prefer-dark";
        document-font-name = "Noto Sans 11";
        enable-animations = true;
        gtk-key-theme = "Emacs";
        text-scaling-factor = 1.25;
        toolkit-accessibility = false;
      };

      "org/gnome/desktop/peripherals/keyboard" = {
        delay = mkUint32 300;
        repeat = true;
        repeat-interval = mkUint32 30;
      };

      "org/gnome/desktop/session" = {
        idle-delay = mkUint32 900;
      };

      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
        titlebar-font = "Noto Sans Bold 11";
      };

      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
        night-light-temperature = mkUint32 3700;
      };

      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-timeout = mkUint32 2700;
      };

      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "appindicatorsupport@rgcjonas.gmail.com"
          "blur-my-shell@aunetx"
          "caffeine@patapon.info"
          "clipboard-indicator@tudmotu.com"
          "gsconnect@andyholmes.github.io"
          "drive-menu@gnome-shell-extensions.gcampax.github.com"
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
        ];
      };

      "org/gnome/desktop/wm/keybindings" = {
        move-to-workspace-1 = ["<Shift><Super>1"];
        move-to-workspace-2 = ["<Shift><Super>2"];
        move-to-workspace-3 = ["<Shift><Super>3"];
        move-to-workspace-4 = ["<Shift><Super>4"];
        switch-to-workspace-1 = ["<Super>1"];
        switch-to-workspace-2 = ["<Super>2"];
        switch-to-workspace-3 = ["<Super>3"];
        switch-to-workspace-4 = ["<Super>4"];
      };

      "org/gnome/shell/keybindings" = {
        switch-to-application-1 = [];
        switch-to-application-2 = [];
        switch-to-application-3 = [];
        switch-to-application-4 = [];
      };
    };
  };
}
