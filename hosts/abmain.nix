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
      # Must stay true: with this false we get silent hard hangs (a lesson
      # relearned 2026-09-09 — the config had drifted back to false). No
      # `finegrained` here: that is for Optimus laptops, not a desktop primary GPU.
      powerManagement.enable = true;
      open = true;
      nvidiaSettings = true;
      # Keep the GPU initialised even with no X client attached: steadier state
      # and better error reporting for the ollama/Steam mix on this box.
      nvidiaPersistenced = true;
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
  };

  programs.steam.enable = true;
  # gamemoderun is referenced in Steam launch options for FPV sims; the module
  # puts it on PATH inside the Steam FHS sandbox. Without this the launch
  # command fails ("gamemoderun: command not found") and the game exits at once.
  programs.gamemode.enable = true;

  # EdgeTX/Radiomaster (incl. TX15) shared HID IDs need hidraw uaccess so
  # FPV simulators (Liftoff) can read the raw HID interface, not just /dev/input/js*.
  services.udev.extraRules = ''
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
