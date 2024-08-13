{ lib, flake-inputs, config, pkgs, ... }:

{
  imports = [
    flake-inputs.ags.homeManagerModules.default
    ../../modules/home-manager
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "24.05";

  home.file.".config/karabiner/karabiner.json".source = ../../static/karabiner.json;

  my = {
    shell.enable = true;
    dev.enable = true;
  };

  # TODO auto download emacs and rime config
  # TODO sync applications config, iterm, raycast
  # TODO auto config rime install id and sync folder
  # TODO replace spotlight with raycast, cmd+space
  # TODO config ctrl+, to switch input method
  # FIXME
  # home.activation.removeExistingRime = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
  #   if [ ! -d $HOME/Library/Rime/.git ]; then
  #      rm -rf ~/Library/Rime
  #      ${pkgs.git} clone https://github.com/mrunhap/rime $HOME/Library/Rime
  #   fi
  # '';
  # home.activation.checkEmacsDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #   if [ ! -d $HOME/.emacs.d/.git ]; then
  #      rm -rf $HOME/.emacs.d
  #      ${pkgs.git} clone https://github.com/mrunhap/.emacs.d $HOME/.emacs.d
  #   fi
  # '';
  # home.activation.checkEmacsRime = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #   if [ ! -d $HOME/.emacs.d/rime ]; then
  #      ${pkgs.git} clone https://github.com/mrunhap/rime $HOME/.emacs.d/rime
  #   fi
  # '';
}
