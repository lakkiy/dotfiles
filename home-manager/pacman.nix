{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./develop
    ./shell
    ./syncthing
  ];

  home.packages = with pkgs; [
  ];

  home = {
    # See https://wiki.archlinux.org/title/Xorg/Keyboard_configuration#Setting_keyboard_layout
    keyboard = {
      variant = "dvorak";
      options = ["grp:caps_toggle"];
    };
  };
}
