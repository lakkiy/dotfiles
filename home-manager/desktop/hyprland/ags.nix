{
  flake-inputs,
  pkgs,
  ...
}: {
  imports = [flake-inputs.ags.homeManagerModules.default];

  programs.ags = {
    enable = true;

    configDir = ./ags;

    # additional packages to add to gjs's runtime
    extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
      accountsservice
    ];
  };
}
