{
  config,
  pkgs,
  lib,
  ...
}: {
  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx5";
    XMODIFIERS = "@im=fcitx5";
    QT_IM_MODULE = "fcitx5";
  };

  home.activation.removeExistingFcitx5 = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    rm -rf ~/.config/fcitx5

    if [ ! -d $HOME/.local/share/fcitx5/rime ]; then
       git clone https://github.com/mrunhap/rime $HOME/.local/share/fcitx5/rime
       fcitx5-remote -r
    fi
  '';
  xdg.configFile.fcitx5.source = ./fcitx5;
}
