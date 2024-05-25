{
  config,
  pkgs,
  ...
}: {
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
  ];
  # gnome system tray, with addindicator
  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

  programs.dconf.enable = true;

  home-manager.users.mrunhap = {
    imports = [
      ../../home-manager/desktop/gnome.nix
      ../../home-manager/desktop/gtk.nix
    ];
  };
}
