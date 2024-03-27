{
  config,
  pkgs,
  ...
}: {
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    dejavu_fonts
    font-awesome_5
    noto-fonts-emoji
    noto-fonts # no 豆腐
    cardo # variable pitch font
    sarasa-gothic # 中英等宽
    lxgw-wenkai # 中文字体
    symbola

    # anything need nerd icon(editor, system bar, etc...)
    (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
  ];
}
