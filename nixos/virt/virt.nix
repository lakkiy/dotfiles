{ config, lib, pkgs, ... }:

{
  # also see https://nixos.wiki/wiki/Virt-manager
  # https://blog.programster.org/kvm-missing-default-network
  # sudo virsh net-start default
  # sudo virsh net-autostart default
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  users.users.mrunhap.extraGroups = [ "libvirtd" ];

  # https://github.com/NixOS/nixpkgs/pull/277845
  # https://discourse.nixos.org/t/virt-manager-cannot-find-virtiofsd/26752
  # https://discourse.nixos.org/t/libvirt-session-mode-and-virtiofs/27857/3
  virtualisation.libvirtd.qemu.vhostUserPackages = [ pkgs.virtiofsd ];

  home-manager.users.mrunhap = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
}
