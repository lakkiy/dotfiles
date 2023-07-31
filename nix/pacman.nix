{ config, pkgs, inputs, ... }:

{
  imports = [
    (import ../modules/fonts.nix)
    (import ../modules/tui.nix)
    (import ../modules/programming.nix)
    (import ../modules/services/syncthing.nix)
  ];

  home.sessionVariables = {
    GTK_IM_MODULE="fcitx5";
    XMODIFIERS="@im=fcitx5";
    QT_IM_MODULE="fcitx5";
  };
  home.file.".config/fcitx5/config".source = ../files/fcitx5_config;
  home.file.".config/fcitx5/profile".source = ../files/fcitx5_profile;

  home = {
    # See https://wiki.archlinux.org/title/Xorg/Keyboard_configuration#Setting_keyboard_layout
    keyboard = {
      variant = "dvorak";
      options = [ "grp:caps_toggle" ];
    };
  };
}
