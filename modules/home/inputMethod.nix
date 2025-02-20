{
  config,
  lib,
  pkgs,
  isDarwin,
  ...
}:
with lib; let
  cfg = config.my.inputMethod;
in {
  options.my.inputMethod = {
    enable = mkEnableOption "inputMethod";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      GTK_IM_MODULE = "fcitx5";
      XMODIFIERS = "@im=fcitx5";
      QT_IM_MODULE = "fcitx5";
    };
    xdg.configFile.fcitx5.source = ../../static/fcitx5;

    # TODO auto download rime config and restart fcitx5
    # rm -rf ~/.config/fcitx5
    # if [ ! -d $HOME/.local/share/fcitx5/rime ]; then
    #    ${pkgs.git} clone https://github.com/lakkiy/rime $HOME/.local/share/fcitx5/rime
    #    fcitx5-remote -r
    # fi
  };
}
