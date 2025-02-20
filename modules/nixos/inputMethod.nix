{
  config,
  lib,
  pkgs,
  user,
  ...
}: {
  options.my.inputMethod = {
    enable = lib.mkEnableOption "inputMethod";
  };

  config = lib.mkIf config.my.inputMethod.enable {
    i18n.inputMethod.enable = true;
    i18n.inputMethod.type = "fcitx5";
    i18n.inputMethod.fcitx5.addons = with pkgs; [fcitx5-rime];

    # https://nixos.wiki/wiki/Home_Manager#Usage_as_a_NixOS_module
    # home-manager module in nixos module so that I don't need to import
    # both nixos's fcitx5 module and home-manager's fcitx5 module
    home-manager.users.${user}.my.inputMethod.enable = true;
  };
}
