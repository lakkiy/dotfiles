{
  pkgs,
  lib,
  config,
  ...
}: {
  nix = {
    package = pkgs.nix;
    optimise.automatic = true;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["lakkiy" "liubo" "root"];
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
}
