{ config, lib, ... }:

{
  # also see https://nixos.wiki/wiki/Virt-manager
  # https://blog.programster.org/kvm-missing-default-network
  # sudo virsh net-start default
  # sudo virsh net-autostart default
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  users.users.gray.extraGroups = [ "libvirtd" ];

  home-manager.users.gray = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
}
