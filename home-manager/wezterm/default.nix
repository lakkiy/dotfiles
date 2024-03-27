{pkgs, ...}: {
  # home.packages = [pkgs.wezterm ];
  # Only set wezterm config file, don't install wezterm here since
  # non-NixOS have to install it with there package manager.
  xdg.configFile.wezterm.source = ./wezterm;
}
