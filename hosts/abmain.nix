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

    printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
    };

    sunshine = {
      enable = true;
      capSysAdmin = false;
      openFirewall = true;
      settings = {
        encoder = "vaapi";
        adapter_name = "/dev/dri/renderD129";
      };
    };
  };

  programs.steam.enable = true;

  # Point Sunshine's vaapi at the NVIDIA GPU
  systemd.user.services.sunshine.environment = {
    LIBVA_DRIVER_NAME = "nvidia";
    LD_LIBRARY_PATH = "/run/opengl-driver/lib";
  };

  # Sunshine needs uinput access for virtual input devices.
  # EdgeTX/Radiomaster (incl. TX15) shared HID IDs need hidraw uaccess so
  # FPV simulators (Liftoff) can read the raw HID interface, not just /dev/input/js*.
  services.udev.extraRules = ''
    KERNEL=="uinput", SUBSYSTEM=="misc", MODE="0660", GROUP="input", TAG+="uaccess", OPTIONS+="static_node=uinput"
    KERNEL=="hidraw*", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="4f54", TAG+="uaccess"
  '';

  # Mount XFS video drive with nouuid to prevent UUID collision after
  # hot-unplug/replug (device name changes sda→sdb→sdc but XFS keeps
  # a stale UUID reference from the previous mount)
  services.udisks2.settings."mount_options.conf" = {
    defaults = {
      xfs_defaults = "nouuid";
      xfs_allow = "nouuid";
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
