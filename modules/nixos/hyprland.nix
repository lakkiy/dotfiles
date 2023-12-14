{ config, pkgs, inputs, ... }:

{
  services.xserver.displayManager.gdm.enable = true;

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    enableNvidiaPatches = true;
  };
}
