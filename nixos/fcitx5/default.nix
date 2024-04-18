{
  config,
  pkgs,
  ...
}: {
  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.addons = with pkgs; [fcitx5-rime];

  # https://nixos.wiki/wiki/Home_Manager#Usage_as_a_NixOS_module
  # home-manager module in nixos module so that I don't need to import
  # both nixos's fcitx5 module and home-manager's fcitx5 module
  home-manager.users.mrunhap = {
    imports = [../../home-manager/fcitx5];
  };

  # TODO auto config rime
  # FIXME source will make kernal panic, not syncthing
  # system.activationScripts.rime.text = ''
  #   source ${config.system.build.setEnvironment}
  #   CONFIG="$HOME/.local/share/fcitx5/rime"

  #   if [ ! -d "$CONFIG" ]; then
  #     git clone https://github.com/mrunhap/rime.git $CONFIG
  #   fi
  # '';
}
