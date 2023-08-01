{ config, pkgs, ... }:

{
  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.addons = with pkgs; [ fcitx5-rime ];

  # FIXME source will make kernal panic, not syncthing
  # system.activationScripts.rime.text = ''
  #   source ${config.system.build.setEnvironment}
  #   CONFIG="$HOME/.local/share/fcitx5/rime"

  #   if [ ! -d "$CONFIG" ]; then
  #     git clone https://github.com/404cn/rime.git $CONFIG
  #   fi
  # '';
}
