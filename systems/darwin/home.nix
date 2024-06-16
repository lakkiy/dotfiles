{ inputs, config, pkgs, ... }:

{
  imports = [ ../../modules/home-manager ];

  home.packages = with pkgs; [
    home-manager
    coreutils
  ];
  home.stateVersion = "24.05";

  my = {
    shell.enable = true;
    dev.enable = true;
  };

  home.file."Pictures/wallpapers".source = ../../static/wallpapers;
  home.file.".config/karabiner/karabiner.json".source = ../../static/karabiner.json;
}
