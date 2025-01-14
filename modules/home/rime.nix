{
  config,
  lib,
  pkgs,
  isDarwin,
  ...
}:
with lib; let
  cfg = config.my.rime;
in {
  options.my.rime = {
    enable = mkEnableOption "rime";
  };

  config = mkIf cfg.enable {
    # TODO set rime on darwin
    home.sessionVariables = {
      GTK_IM_MODULE = "fcitx5";
      XMODIFIERS = "@im=fcitx5";
      QT_IM_MODULE = "fcitx5";
    };
    xdg.configFile.fcitx5.source = ../../static/fcitx5;

    # FIXME Failed to start Home Manager environment for lakkiy, /nix/store/git
    # is a directory
    # home.activation.removeExistingFcitx5 = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    #   rm -rf ~/.config/fcitx5
    #
    #   if [ ! -d $HOME/.local/share/fcitx5/rime ]; then
    #      ${pkgs.git} clone https://github.com/lakkiy/rime $HOME/.local/share/fcitx5/rime
    #      fcitx5-remote -r
    #   fi
    #     '';
  };
}
