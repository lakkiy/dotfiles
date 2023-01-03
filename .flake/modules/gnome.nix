{ config, pkgs, ...}:

{
  home.packages = with pkgs; [
    gnome.gnome-tweaks
    gnomeExtensions.blur-my-shell
    gnomeExtensions.appindicator
    pop-gtk-theme
    pop-icon-theme
    gnomeExtensions.gsconnect
    gnomeExtensions.caffeine
    gnomeExtensions.pop-shell
  ];
}
