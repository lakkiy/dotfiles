{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.my.fcitx5;

in {
  options.my.fcitx5 = {
    enable = mkEnableOption "fcitx5";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      GTK_IM_MODULE = "fcitx5";
      XMODIFIERS = "@im=fcitx5";
      QT_IM_MODULE = "fcitx5";
    };

    # FIXME git command not found on first time home manager generation
    home.activation.removeExistingFcitx5 = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    rm -rf ~/.config/fcitx5

    if [ ! -d $HOME/.local/share/fcitx5/rime ]; then
       git clone https://github.com/mrunhap/rime $HOME/.local/share/fcitx5/rime
       fcitx5-remote -r
    fi
    '';
    xdg.configFile.fcitx5.source = ../../../static/fcitx5;
  };
}
