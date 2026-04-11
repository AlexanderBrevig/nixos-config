{ config, pkgs, lib, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = "abmain";

  boot.kernelParams = [
    "amd_pstate=active"
    "nvidia-drm.modeset=1"
  ];

  hardware = {
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      open = true;
      nvidiaSettings = true;
    };

    graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        vulkan-validation-layers
        vulkan-tools
      ];
    };

    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableRedistributableFirmware = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  services = {
    fwupd.enable = true;

    ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
    };

    sunshine = {
      enable = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };

  environment.systemPackages = with pkgs; [
    lm_sensors
    nvtopPackages.nvidia
    vulkan-tools
    mesa-demos
    davinci-resolve
    davinci-resolve-studio
  ];
}
