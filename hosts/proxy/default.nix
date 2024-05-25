{
  config,
  lib,
  ...
}: {
  services.dae = {
    enable = true;
    # make sure to create the config file
    # global{}
    # routing{}
    configFile = "/etc/dae/config.dae";
  };
}
