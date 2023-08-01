{ config, pkgs, lib, ... }:

{
  home.sessionVariables = {
    GTK_IM_MODULE="fcitx5";
    XMODIFIERS="@im=fcitx5";
    QT_IM_MODULE="fcitx5";
  };

  home.activation.removeExistingFcitx5 = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    rm -rf ~/.config/fcitx5
    rm -rf ~/.local/share/fcitx5/themes
  '';
  home.file.".config/fcitx5" = {
    source = ../../modules/files/fcitx5;
    recursive = true;
  };
  home.file.".local/share/fcitx5/themes" = {
    source = ../../modules/files/fcitx5-theme;
    recursive = true;
  };

  # TODO check rime
}
