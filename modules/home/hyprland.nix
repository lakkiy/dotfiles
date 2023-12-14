{ lib, config, pkgs, inputs, ... }:

# TODO this should not build from source

{
  home.file.".config/wlogout" = {
    source = ../files/wlogout;
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
    kitty = {
      enable = true;
      extraConfig = ''
background_opacity 0.5

window_margin_width 3
window_padding_width 3

tab_bar_style separator
tab_title_template "{index}:{title}"

map ctrl+shift+alt+t set_tab_title
map ctrl+tab goto_tab -1
map alt+1 goto_tab 1
map alt+2 goto_tab 2
map alt+3 goto_tab 3
map alt+4 goto_tab 4
map alt+5 goto_tab 5
map alt+6 goto_tab 6
map alt+7 goto_tab 7
map alt+8 goto_tab 8
map alt+9 goto_tab 9
map alt+0 goto_tab 10
     '';
    };
    wlogout = {
      # enable before waybar
      enable = true;
    };
  };
}
