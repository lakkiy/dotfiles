{ inputs, lib, config, pkgs, ... }:

{
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["mrunhap" "liubo" "root"];
    };
    # Enable nixFlakes on system
    package = pkgs.nixVersions.latest;

    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    # nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
    registry.nixpkgs.flake = inputs.nixpkgs;
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  programs = {
    home-manager.enable = true;
    git.enable = true;
    bash.enable = true;
  };
  # Make GUI applications show in menu.
  targets.genericLinux.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";

  home = {
    # See https://wiki.archlinux.org/title/Xorg/Keyboard_configuration#Setting_keyboard_layout
    keyboard = {
      variant = "dvorak";
      options = ["grp:caps_toggle"];
    };
  };

  home.file."Pictures/wallpapers".source = ../../static/wallpapers;
}
