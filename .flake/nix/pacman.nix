{ config, pkgs, inputs, ... }:

{
  imports = [
    (import ../modules/terminal.nix)
    (import ../modules/programming.nix)
    (import ../modules/zsh.nix)
    (import ../modules/app.nix)
    (import ../modules/video.nix)
    (import ../modules/fonts.nix)
    (import ../modules/gnome.nix)
    (import ../modules/fcitx5.nix)
    (import ../modules/syncthing.nix)
#   (import ../modules/dropbox.nix)
    (import ../modules/proxy.nix)
  ];

  programs = {
  };

  home = {
    # See https://wiki.archlinux.org/title/Xorg/Keyboard_configuration#Setting_keyboard_layout
    keyboard = {
      variant = [ "dvorak" ];
      options = [ "grp:caps_toggle" ];
    };

    packages = with pkgs; [

    ];
  };
}
