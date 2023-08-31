{ lib, config, pkgs, inputs, ... }:

{
  imports = [
    (import ../modules/tui.nix)
    (import ../modules/programming.nix)
    (import ../modules/home/syncthing.nix)
    (import ../modules/home/fonts.nix)
    (import ../modules/home/fcitx5.nix)
  ];

  home.file.".config/kitty/kitty.conf".source = ../modules/files/kitty.conf;

  home.packages = with pkgs; [
    config.nur.repos.xddxdd.wechat-uos-bin
    qq
  ];

  home = {
    # See https://wiki.archlinux.org/title/Xorg/Keyboard_configuration#Setting_keyboard_layout
    keyboard = {
      variant = "dvorak";
      options = [ "grp:caps_toggle" ];
    };
  };
}
