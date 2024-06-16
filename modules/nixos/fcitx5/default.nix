{ config, lib, pkgs, ... }:

{
  options.my.fcitx5 = {
    enable = lib.mkEnableOption "fcitx5";
  };

  config = lib.mkIf config.my.fcitx5.enable {
    i18n.inputMethod.enabled = "fcitx5";
    i18n.inputMethod.fcitx5.addons = with pkgs; [fcitx5-rime];

    # https://nixos.wiki/wiki/Home_Manager#Usage_as_a_NixOS_module
    # home-manager module in nixos module so that I don't need to import
    # both nixos's fcitx5 module and home-manager's fcitx5 module
    home-manager.users.mrunhap = {
      imports = [ ../../home-manager/programs/fcitx5.nix ];
      my.fcitx5.enable = true;
    };
  };
}
