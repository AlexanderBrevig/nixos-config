# Desktop workstation configuration with NVIDIA
{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Hostname
  networking.hostName = "abstation";

  # Boot configuration with LUKS encryption
  boot = {
    initrd = {
      availableKernelModules = [ 
        "nvme" 
        "xhci_pci" 
        "ahci" 
        "usbhid" 
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

  # Hardware configuration for workstation
  hardware = {
    # NVIDIA proprietary drivers
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false; # Use proprietary drivers
      nvidiaSettings = true;
      
      # Specify driver version (remove if you want latest)
      # package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # OpenGL/Vulkan support
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      
      extraPackages = with pkgs; [
        # NVIDIA packages
        nvidia-vaapi-driver
        vaapiVdpau
        libvdpau-va-gl
        
        # Vulkan
        vulkan-validation-layers
        vulkan-tools
      ];
    };

    # CPU microcode
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    
    # Enable firmware updates
    enableRedistributableFirmware = true;
  };

  # Load NVIDIA driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  # Desktop-specific services
  services = {
    # Better mouse/keyboard support for gaming
    libinput.enable = true;
    
    # Enable Docker for development
    docker = {
      enable = true;
      enableOnBoot = true;
    };
    
    # Enable virtualization
    libvirtd.enable = true;
  };

  # Workstation-specific packages
  environment.systemPackages = with pkgs; [
    # System monitoring
    lm_sensors
    nvtop      # NVIDIA GPU monitoring
    nvidia-smi # NVIDIA system management
    
    # Virtualization tools
    virt-manager
    qemu
    
    # Development containers
    docker-compose
    
    # GPU tools
    vulkan-tools
    glxinfo
    
    # Performance tools
    stress-ng
    memtester
  ];

  # Workstation optimizations
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance"; # Performance mode for workstation
  };

  # Desktop networking (Ethernet preferred)
  networking = {
    # If you have both WiFi and Ethernet, prioritize Ethernet
    networkmanager.insertNameservers = [ "1.1.1.1" "8.8.8.8" ];
  };

  # Workstation-specific kernel parameters
  boot.kernelParams = [
    # NVIDIA optimizations
    "nvidia-drm.modeset=1"
    
    # Performance optimizations
    "intel_pstate=active"
    "mitigations=off"  # Disable CPU mitigations for performance (less secure)
  ];

  # Enable firmware updates
  services.fwupd.enable = true;

  # Gaming and multimedia optimizations
  programs = {
    # Steam gaming
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    
    # GameMode for optimized gaming performance
    gamemode.enable = true;
  };

  # Additional virtualization support
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull.fd ];
        };
      };
    };
    
    docker = {
      enable = true;
      enableNvidia = true; # Enable NVIDIA container runtime
    };
  };
}