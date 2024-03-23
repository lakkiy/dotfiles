{ config, pkgs, lib, ... }:

{
  home.sessionVariables = {
    GTK_IM_MODULE="fcitx5";
    XMODIFIERS="@im=fcitx5";
    QT_IM_MODULE="fcitx5";
  };

  home.activation.removeExistingFcitx5 = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    rm -rf ~/.config/fcitx5
  '';
  home.file.".config/fcitx5" = {
    source = ../files/fcitx5;
    recursive = true;
  };
  # TODO check rime
}
