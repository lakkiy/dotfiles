{ config, pkgs, inputs, ... }:

{
  services.xserver.displayManager.gdm.enable = true;

  services.gvfs.enable = true; # smb for nautilus
  environment.systemPackages = with pkgs; [
    gnome.nautilus
    gnome.eog # image viewer
    gnome.evince # pdf viewer
  ];

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    enableNvidiaPatches = true;
  };
}
