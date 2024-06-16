{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.my.font;

in {
  options.my.font = {
    enable = mkEnableOption "font";
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      # no 豆腐
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      noto-fonts-emoji-blob-bin
      noto-fonts-monochrome-emoji

      roboto-mono
      dejavu_fonts
      font-awesome_5
      cardo # variable pitch font
      sarasa-gothic # 中英等宽
      lxgw-wenkai # 中文字体
      symbola

      # anything need nerd icon(editor, system bar, etc...)
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];
  };
}
