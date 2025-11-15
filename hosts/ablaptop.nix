# Laptop-specific configuration (Lenovo ThinkPad T14 Gen 6)
{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Hostname
  networking.hostName = "ablaptop";

  # Boot configuration with LUKS encryption
  boot = {
    # Enable LUKS2 encryption
    initrd = {
      availableKernelModules = [ 
        "nvme" 
        "xhci_pci" 
        "thunderbolt" 
        "usb_storage" 
        "sd_mod" 
        # LUKS support
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
      
      # Uncomment and configure LUKS after installation
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

  # File systems - customize these after installation
  fileSystems = {
    "/" = {
      # Update this device path after installation
      device = "/dev/disk/by-uuid/ROOT-UUID-HERE";
      fsType = "ext4";
    };

    "/boot" = {
      # Update this device path after installation  
      device = "/dev/disk/by-uuid/BOOT-UUID-HERE";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
  };

  # Swap configuration
  swapDevices = [
    # Uncomment and configure after installation
    # { device = "/dev/disk/by-uuid/SWAP-UUID-HERE"; }
  ];

  # Hardware-specific configurations
  hardware = {
    # Intel integrated graphics
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver  # LIBVA_DRIVER_NAME=iHD
        vaapiIntel          # LIBVA_DRIVER_NAME=i965 (older hardware)
        vaapiVdpau
        libvdpau-va-gl
      ];
    };

    # CPU microcode updates
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    
    # Enable firmware updates
    enableRedistributableFirmware = true;
  };

  # Laptop-specific services
  services = {
    # ThermalD for thermal management
    thermald.enable = true;
    
    # Auto-rotate screen based on orientation (if supported)
    # iio-sensor-proxy.enable = true;
    
    # Better touchpad support
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        tapping = true;
        clickMethod = "clickfinger";
        accelProfile = "adaptive";
      };
    };

    # Laptop power management
    tlp = {
      enable = false; # Disabled in favor of power-profiles-daemon
    };
    
    # Alternative: Use power-profiles-daemon (enabled in shared.nix)
    # This is more modern and integrates better with GNOME/Wayland
  };

  # ThinkPad specific packages
  environment.systemPackages = with pkgs; [
    # ThinkPad utilities
    lm_sensors
    powertop
    acpi
    
    # Battery monitoring
    upower
    
    # Intel GPU tools
    intel-gpu-tools
  ];

  # Power management optimizations
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };

  # Laptop networking (prioritize WiFi over Ethernet when available)
  networking = {
    networkmanager = {
      wifi = {
        powersave = true;
        scanRandMacAddress = true;
      };
    };
  };

  # Enable fwupd for firmware updates
  services.fwupd.enable = true;

  # Laptop-specific kernel parameters
  boot.kernelParams = [
    # Intel graphics optimizations
    "i915.fastboot=1"
    "i915.enable_fbc=1"
    
    # Power savings
    "intel_pstate=active"
  ];
}