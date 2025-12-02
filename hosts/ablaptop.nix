{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  networking.hostName = "ablaptop";

  boot = {
    initrd = {
      availableKernelModules = [ 
        "nvme" 
        "xhci_pci" 
        "thunderbolt" 
        "usb_storage"
        "sd_mod"
        "aes"
        "aes_generic"
        "blowfish"
        "twofish"
        "serpent"
        "cbc"
        "xts"
        "lrw"
        "sha1"
        "sha256"
        "sha512"
      ];
      
      # luks.devices."luks-root" = {
      #   device = "/dev/disk/by-uuid/YOUR-LUKS-UUID-HERE";
      #   keyFile = null;
      #   allowDiscards = true;
      #   bypassWorkqueues = true;
      # };
    };
    
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/ROOT-UUID-HERE";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/BOOT-UUID-HERE";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };

  swapDevices = [
    # { device = "/dev/disk/by-uuid/SWAP-UUID-HERE"; }
  ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    
    enableRedistributableFirmware = true;
  };

  services = {
    thermald.enable = true;

    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        tapping = true;
        clickMethod = "clickfinger";
        accelProfile = "adaptive";
      };
    };

    tlp.enable = false;
  };

  environment.systemPackages = with pkgs; [
    lm_sensors
    powertop
    acpi
    
    upower
    
    intel-gpu-tools
  ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };

  networking = {
    networkmanager = {
      wifi = {
        powersave = true;
        scanRandMacAddress = true;
      };
    };
  };

  services.fwupd.enable = true;

  boot.kernelParams = [
    "i915.fastboot=1"
    "i915.enable_fbc=1"
    
    "intel_pstate=active"
  ];
}
