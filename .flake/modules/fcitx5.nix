{ config, pkgs, ...}:

{
  # systemctl --user start fcitx5-daemon
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-rime ];
  };
  home.sessionVariables = {
    GTK_IM_MODULE="fcitx5";
    XMODIFIERS="@im=fcitx5";
    QT_IM_MODULE="fcitx5";
  };
}
