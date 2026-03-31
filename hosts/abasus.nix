{ config, pkgs, lib, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = "abasus";

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "i915.enable_fbc=1"
    "intel_pstate=active"
  ];

  hardware = {
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = true;
      open = false;
      nvidiaSettings = true;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
        nvidia-vaapi-driver
        vulkan-validation-layers
        vulkan-tools
      ];
    };

    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableRedistributableFirmware = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  services = {
    thermald.enable = true;
    fwupd.enable = true;

    printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  environment.systemPackages = with pkgs; [
    lm_sensors
    powertop
    acpi
    upower
    intel-gpu-tools
    nvtopPackages.nvidia
    vulkan-tools
    mesa-demos
    davinci-resolve-studio
  ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };

  networking.networkmanager.wifi = {
    powersave = true;
    scanRandMacAddress = true;
  };

}
