{ config, pkgs, ...}:

{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-rime ];
  };
  # systemctl --user start fcitx5-daemon
}
