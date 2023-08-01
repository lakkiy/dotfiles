{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    # TODO read from modules/files/kitty.conf
    extraConfig = ''
background_opacity 0.5

window_margin_width 3
window_padding_width 3

tab_bar_style separator
tab_title_template "{index}:{title}"

map ctrl+shift+alt+t set_tab_title
map ctrl+tab goto_tab -1
map alt+1 goto_tab 1
map alt+2 goto_tab 2
map alt+3 goto_tab 3
map alt+4 goto_tab 4
map alt+5 goto_tab 5
map alt+6 goto_tab 6
map alt+7 goto_tab 7
map alt+8 goto_tab 8
map alt+9 goto_tab 9
map alt+0 goto_tab 10
    '';
  };
}
