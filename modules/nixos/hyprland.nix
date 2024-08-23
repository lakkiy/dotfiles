{
  config,
  lib,
  pkgs,
  user,
  ...
}: {
  options.my.hyprland = {
    enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf config.my.hyprland.enable {
    # for now, ly module not in nixos or don't support hyprland
    # may change to another display manager
    services.xserver.displayManager.gdm.enable = true;

    programs.hyprland.enable = true;

    home-manager.users.${user} = {
      my.hyprland.enable = true;
      my.gtk.enable = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gnome];
    };

    environment.systemPackages = with pkgs; [
    ];

    # Authentication Agent
    security.polkit.enable = true;
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    # samba support for GTK-based file managers like
    services.gvfs.enable = true;
  };
}
