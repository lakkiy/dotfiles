{
  config,
  pkgs,
  ...
}: {
  services.vsftpd = {
    enable = true;
    writeEnable = true;
    localUsers = true;
    # make sure add port to networking.firewall.allowedTCPPorts
    extraConfig = "
      listen_port=2121
    ";
  };
}
