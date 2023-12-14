{ lib, config, pkgs, inputs, ... }:

{
  services.swayidle.enable = true;
  programs.wlogout.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    xwayland.enable = true;
  };

  home.packages = with pkgs; [
    bemenu # dmenu for wayland
    wlrctl # switch to application or run it
    gtklock #FIXME can't login, keep saying wrong password
    networkmanagerapplet

    blueberry     # bluetooth manager
    inotify-tools # for ags

    # wayland
    wl-gammactl   # Contrast, brightness, and gamma adjustments
    wl-clipboard
    wf-recorder   # screen recording
    hyprpicker    # color picker for wayland
    wayshot       # screenshot
    swappy        # snapshot editing
    slurp
    imagemagick   # for bitmap images
    pwvucontrol   # pipewire volume control, replace pavucontrol
    brightnessctl # control device brightness
    swww          # animated wallpaper for wayland
  ];

  home.file.".config/wlogout" = {
    source = ../files/wlogout;
    recursive = true;
  };

  home.file.".config/hypr" = {
    source = ../files/hypr;
    recursive = true;
  };
}
