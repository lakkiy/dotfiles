{ lib, config, pkgs, inputs, ... }:

# TODO this should not build from source

{
  home.file.".config/wlogout" = {
    source = ../files/wlogout;
    recursive = true;
  };
  home.file."Pictures/wallpapers/default.jpg".source = ../files/default.jpg;

  home.packages = with pkgs; [
    swaybg
    networkmanagerapplet
    gtklock
    bemenu
    grim
    slurp
    # ags and it's dep
    ags
    swww # animated wallpaper for wayland
    sassc # front end for libsass
    brightnessctl # control device brightness
    hyprpicker # color picker for wayland
    wf-recorder # screen recording
    wayshot # screenshot
    imagemagick # for bitmap images
    wl-gammactl # Contrast, brightness, and gamma adjustments
    pwvucontrol # pipewire volume control, replace pavucontrol
  ];

  services = {
    swayidle = {
      enable = true;
    };
    mako = {
      enable = true;
      defaultTimeout = 5;
      extraConfig = ''
background-color=#eff1f5
text-color=#4c4f69
border-color=#1e66f5
progress-color=over #ccd0da

[urgency=high]
border-color=#fe640b
      '';
    };
  };

  programs = {
    kitty = {
      enable = true;
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
    wlogout = {
      # enable before waybar
      enable = true;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    extraConfig = ''
# monitor=,preferred,auto,auto
monitor=DP-3,3840x2160@144,1440x0,1.5,bitdepth,10
monitor=DP-2,3840x2160,0x0,1.5,transform,1
monitor=HDMI-A-2,preferred,1440x1360,auto,transform,3

# default workspace
workspace = name:default, monitor:DP-3, default:true

exec-once = mako & nm-applet --indicator & fcitx5 -d
exec-once = swaybg -i "$HOME/Pictures/wallpapers/default.jpg"
exec-once = swayidle -w timeout 1800 'systemctl suspend'
exec-once = hyprctl setcursor Bibata-Modern-Amber 32
exec-once = emacs --daemon

# Some default env vars.
env = XCURSOR_SIZE,24

# Nvidia, include can't see cursor
# env = LIBVA_DRIVER_NAME,nvidia
# env = XDG_SESSION_TYPE,wayland
# env = GBM_BACKEND,nvidia-drm
# env = __GLX_VENDOR_LIBRARY_NAME,nvidia
env = WLR_NO_HARDWARE_CURSORS,1

$mainMod = SUPER


# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
bind = $mainMod, return, exec, kitty
bind = $mainMod_SHIFT, C, togglegroup,
bind = $mainMod, B, exec, firefox
bind = $mainMod, Q, killactive,
bind = $mainMod, E, exec, emacs
bind = $mainMod, L, exec, gtklock
bind = $mainMod, D, exec, bemenu-run -i --fn 'Sarasa Gothic SC 20'
bind = $mainMod_SHIFT, space, togglefloating,
bind = $mainMod, P, pseudo, # dwindle
bind = $mainMod, f, fullscreen, # dwindle
bind = $mainMod_SHIFT, p, exec, grimblast copysave area

# Scroll through existing workspaces with mainMod + scroll
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

# For all categories, see https://wiki.hyprland.org/Configuring/Variables/
input {
    kb_layout = us
    kb_variant = dvorak
    repeat_rate = 60
    repeat_delay = 150
}

general {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border=rgb(cdd6f4)
    col.inactive_border = rgba(595959aa)

    layout = dwindle
}

decoration {
    rounding = 10
    drop_shadow = true
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
    blur {
         enabled = true
         size = 7
         passes = 4
         new_optimizations = true
    }
}

animations {
    enabled = true
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    animation = windows, 1, 7, myBezier, slide
    animation = windowsOut, 1, 7, myBezier, slide
    animation = border, 1, 10, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

dwindle {
    pseudotile = true
    preserve_split = true
}

# only blur emacs and kitty
windowrule = noblur,^(?!emacs$|kitty$).*$

# Scratchpad
bind = $mainMod_SHIFT, c, movetoworkspace, special
bind = $mainMod , c, togglespecialworkspace,

# Move focus with mainMod + arrow keys
bind = $mainMod, h, movefocus, l
bind = $mainMod, s, movefocus, r
bind = $mainMod, t, movefocus, u
bind = $mainMod, n, movefocus, d

# Move window
bind = $mainMod_SHIFT, h, movewindow, l
bind = $mainMod_SHIFT, s, movewindow, r
bind = $mainMod_SHIFT, t, movewindow, u
bind = $mainMod_SHIFT, n, movewindow, d

# Use , .(find key code with wev)
bind = $mainMod, code:25, changegroupactive, b
bind = $mainMod, code:26, changegroupactive, f

# Switch workspaces with mainMod + [0-9]
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Move active window to a workspace with mainMod + SHIFT + [0-9]
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10
    '';
  };
}
