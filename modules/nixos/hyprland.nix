{ config, pkgs, ... }:

{
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      enableNvidiaPatches = true;
    };
    waybar = {
      enable = true;
      package = pkgs.waybar-hyprland;
    };
    nm-applet = {
      enable = true;
      indicator = true;
    };
  };
  environment.systemPackages = with pkgs; [
    mako
    wlogout
    swaybg
    swayidle
    gtklock
    bemenu
    grim
    slurp
    fuzzel
    foot
  ];
}
