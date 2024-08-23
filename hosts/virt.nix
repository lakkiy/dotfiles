{
  nixpkgs,
  system,
  hostName,
  user,
}: {
  root = {
  };

  module = {
    pkgs,
    config,
    lib,
    ...
  }: {
    my.dev.enable = true;
  };
}
