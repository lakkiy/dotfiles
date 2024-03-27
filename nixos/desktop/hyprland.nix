{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.hyprland.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gnome];
  };

  environment.systemPackages = with pkgs; [
    gnome.nautilus # file manager
    gnome.eog # image viewer
    gnome.evince # pdf viewer

    # Automatically Mounting
    # udiskie is a udisks2 front-end that allows to manage removable
    # media such as CDs or flash drives from userspace.
    udiskie
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

  # display manager, maybe replace with ly(don't supprot hyprland for now?)
  services.xserver.displayManager.gdm.enable = true;

  # samba support for GTK-based file managers like
  services.gvfs.enable = true;

  home-manager.users.gray = {
    imports = [
      ../../home-manager/desktop/hyprland.nix
      ../../home-manager/desktop/gtk.nix
    ];
  };
}
