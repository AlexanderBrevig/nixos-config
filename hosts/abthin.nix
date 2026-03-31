{ config, pkgs, lib, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = "abthin";

  boot.kernelParams = [
    "amd_pstate=active"
  ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        vulkan-validation-layers
        vulkan-tools
      ];
    };

    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableRedistributableFirmware = true;
  };

  services = {
    fwupd.enable = true;
  };

  environment.systemPackages = with pkgs; [
    lm_sensors
    powertop
    acpi
    upower
    vulkan-tools
    mesa-demos
  ];

  powerManagement.enable = true;

  networking.networkmanager.wifi = {
    powersave = true;
    scanRandMacAddress = true;
  };
}
