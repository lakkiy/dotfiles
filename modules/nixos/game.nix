{
  config,
  lib,
  pkgs,
  ...
}: {
  options.my.game = {
    enable = lib.mkEnableOption "Game";
  };

  config = lib.mkIf config.my.game.enable {
    # TODO gaming on nixos linux like steamdeck
    #      also run windows game like yugioh master duel
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
  };
}
