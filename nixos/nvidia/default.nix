{
  config,
  pkgs,
  ...
}: {

  # https://nixos.wiki/wiki/Nvidia
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Tell Xorg to use the nvidia driver (also valid for Wayland)
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is needed for most Wayland compositors
    modesetting.enable = true;

    # Optionally, you may need to select the appropriate driver version
    # for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Enable the nvidia settings menu
    nvidiaSettings = true;
  };

  # https://wiki.hyprland.org/Nvidia/#fixing-suspendwakeup-issues
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];
  # Nvidia power management. Experimental, and can cause sleep/suspend
  # to fail.
  # Enable this if you have graphical corruption issues or application
  # crashes after waking up from sleep. This fixes it by saving the
  # entire VRAM memory to /tmp/ instead of just the bare essentials.
  hardware.nvidia.powerManagement.enable = true;
  # Fine-grained power management. Turns off GPU when not in use.
  # Experimental and only works on modern Nvidia GPUs (Turing or newer).
  hardware.nvidia.powerManagement.finegrained = false;
  # Making sure to use the proprietary drivers until the issue above
  # is fixed upstream.
  hardware.nvidia.open = false;

  environment.systemPackages = with pkgs; [
    nvtop-nvidia
  ];
}
