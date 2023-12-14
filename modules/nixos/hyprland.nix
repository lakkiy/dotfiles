{ config, pkgs, ... }:

{
  services.xserver.displayManager.gdm.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    enableNvidiaPatches = true;
  };
  programs.nm-applet = {
    enable = true;
    indicator = true;
  };

  environment.systemPackages = with pkgs; [
    wlogout
    swaybg
    swayidle
    gtklock
    bemenu
    grim
    slurp
    wezterm
    # replace wezterm and bemenu ?
    fuzzel
    foot
  ];
}
