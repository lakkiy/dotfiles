{ lib, config, pkgs, inputs, ... }:

{
  imports = [
    (import ./shell.nix)
    (import ./programming.nix)
    (import ./syncthing.nix)
    (import ./fonts.nix)
    (import ./fcitx5.nix)
    (import ./gtk.nix)
  ];

  home.packages = with pkgs; [
    qq

    inputs.ags.packages.${pkgs.system}.default
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
    inotify-tools
  ];

  home = {
    # See https://wiki.archlinux.org/title/Xorg/Keyboard_configuration#Setting_keyboard_layout
    keyboard = {
      variant = "dvorak";
      options = [ "grp:caps_toggle" ];
    };
  };
}
