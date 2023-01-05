{ config, pkgs, inputs, ... }:

{
  imports = [
    (import ../modules/terminal.nix)
    (import ../modules/programming.nix)
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

  nix = {                                               # Nix Package Manager settings
    settings ={
      auto-optimise-store = true;                       # Optimise syslinks
      experimental-features = [ "nix-command" "flakes" ];
    };
    package = pkgs.nixFlakes;                           # Enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
  };
  nixpkgs.config.allowUnfree = true;                    # Allow proprietary software.
  # https://github.com/nix-community/home-manager/issues/2942#issuecomment-1119760100
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
}
