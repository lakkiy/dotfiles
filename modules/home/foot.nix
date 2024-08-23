{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.foot;
in {
  options.my.foot = {
    enable = mkEnableOption "foot";
  };

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          font = "Latin Modern Mono:size=17";
          pad = "10x10";
        };
        colors = {
          foreground = "282828";
          background = "ffffff";
          # alpha=0.7

          # Normal/bright colors (color palette 0-7)
          bright0 = "808080"; # black
          bright1 = "a60000"; # red
          bright2 = "006800"; # green
          bright3 = "6f5500"; # yellow
          bright4 = "0031a9"; # blue
          bright5 = "721045"; # magenta
          bright6 = "005e8b"; # cyan
          bright7 = "000000"; # white

          ## Bright colors (color palette 8-15)
          regular0 = "606060"; # regular black
          regular1 = "b22222"; # regular red
          regular2 = "228b22"; # regular green
          regular3 = "a0522d"; # regular yellow
          regular4 = "483d8b"; # regular blue
          regular5 = "a020f0"; # regular magenta
          regular6 = "008b8b";
          regular7 = "595959"; # regular white
        };
      };
    };
  };
}
