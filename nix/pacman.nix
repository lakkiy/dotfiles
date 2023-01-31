{ config, pkgs, inputs, nixgl, ... }:

{
  imports = [
    (import ../modules/app.nix)
    (import ../modules/emacs.nix)
    (import ../modules/fcitx5.nix)
    (import ../modules/fonts.nix)
    (import ../modules/git.nix)
    (import ../modules/programming.nix)
    (import ../modules/syncthing.nix)
    (import ../modules/terminal.nix)
    (import ../modules/zsh.nix)
    # (import ../modules/dropbox.nix)
  ];

  programs = {
  };

  home = {
    # See https://wiki.archlinux.org/title/Xorg/Keyboard_configuration#Setting_keyboard_layout
    keyboard = {
      variant = "dvorak";
      options = [ "grp:caps_toggle" ];
    };

    packages = with pkgs; [
      (import nixgl { inherit pkgs; }).nixGLIntel
                                     #.nixVulkanIntel
    ];
  };
}
