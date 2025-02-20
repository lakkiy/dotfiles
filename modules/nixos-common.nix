{
  pkgs,
  lib,
  config,
  ...
}: {
  # wayland support for electron base app
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Always enable the shell system-wide, even if it's already enabled in
  # your home.nix. Otherwise it wont source the necessary files.
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  # get zsh completion for system packages (e.g. systemd)
  environment.pathsToLink = ["/share/zsh"];
  # Many programs look at /etc/shells to determine if a user is a
  # "normal" user and not a "system" user. Therefore it is recommended
  # to add the user shells to this list. To add a shell to /etc/shells
  # use the following line in your config:
  environment.shells = with pkgs; [zsh];

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "dvorak";

  # Use keyd to remap keys
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = ["*"];
      settings = {
        main = {
          capslock = "overload(control, esc)";
          control = "overload(control, esc)";
        };
      };
    };
  };
}
