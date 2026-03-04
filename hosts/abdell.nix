{ config, pkgs, lib, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = "abdell";

  boot.kernelParams = [
    "i915.enable_fbc=1"
    "intel_pstate=active"
  ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
        vulkan-validation-layers
        vulkan-tools
      ];
    };

    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableRedistributableFirmware = true;
  };

  services = {
    thermald.enable = false;
    fwupd.enable = true;
  };

  environment.systemPackages = with pkgs; [
    lm_sensors
    powertop
    acpi
    upower
    intel-gpu-tools
    vulkan-tools
    mesa-demos
  ];

  powerManagement.enable = true;

  networking.networkmanager.wifi = {
    powersave = true;
    scanRandMacAddress = true;
  };

}
