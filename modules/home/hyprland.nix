{ lib, config, pkgs, inputs, ... }:

# TODO this should not build from source

{
  home.file.".config/wlogout" = {
    source = ../files/wlogout;
    recursive = true;
  };
  home.file.".config/wezterm" = {
    source = ../files/wezterm;
    recursive = true;
  };

  home.file."Pictures/wallpapers/default.jpg".source = ../files/default.jpg;

  home.file.".config/hypr" = {
    source = ../files/hypr;
    recursive = true;
  };

  home.file.".config/ags" = {
    source = ../files/ags;
    recursive = true;
  };

  home.packages = with pkgs; [
    swaybg
    networkmanagerapplet
    gtklock
    bemenu
    grim
    slurp
    # ags and it's dep
    ags
    blueberry # bluetooth manager
    swww # animated wallpaper for wayland
    sassc # front end for libsass
    brightnessctl # control device brightness
    hyprpicker # color picker for wayland
    wf-recorder # screen recording
    wayshot # screenshot
    imagemagick # for bitmap images
    wl-gammactl # Contrast, brightness, and gamma adjustments
    pwvucontrol # pipewire volume control, replace pavucontrol
  ];

  services = {
    swayidle = {
      enable = true;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
  };

  programs = {
    wezterm = {
      enable = true;
    };
    wlogout = {
      # enable before waybar
      enable = true;
    };
  };
}
