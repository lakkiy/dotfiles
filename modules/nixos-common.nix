{
  pkgs,
  lib,
  config,
  ...
}: {
  # Nix configuration
  nix = {
    package = pkgs.nix;
    optimise.automatic = true;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["lakkiy" "lakki" "liubo" "root"];
      substituters = [
        # cache mirror located in China
        # status: https://mirror.sjtu.edu.cn/
        # "https://mirror.sjtu.edu.cn/nix-channels/store"
        # status: https://mirrors.ustc.edu.cn/status/
        "https://mirrors.ustc.edu.cn/nix-channels/store"

        "https://cache.nixos.org"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Needed to build the flake.
  environment.systemPackages = [pkgs.git];

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
