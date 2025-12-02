{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  networking.hostName = "abstation";

  boot = {
    initrd = {
      availableKernelModules = [ 
        "nvme" 
        "xhci_pci" 
        "ahci" 
        "usbhid" 
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

  swapDevices = [
    # { device = "/dev/disk/by-uuid/SWAP-UUID-HERE"; }
  ];

  hardware = {
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      
      # package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        vaapiVdpau
        libvdpau-va-gl

        vulkan-validation-layers
        vulkan-tools
      ];
    };

    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    
    enableRedistributableFirmware = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  services = {
    libinput.enable = true;
    libvirtd.enable = true;
  };

  environment.systemPackages = with pkgs; [
    lm_sensors
    nvtop
    nvidia-smi

    virt-manager
    qemu
    
    docker-compose
    
    vulkan-tools
    glxinfo
    
    stress-ng
    memtester
  ];

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  networking = {
    networkmanager.insertNameservers = [ "1.1.1.1" "8.8.8.8" ];
  };

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "intel_pstate=active"
  ];

  services.fwupd.enable = true;

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    
    gamemode.enable = true;
  };

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

    docker.enableNvidia = true;
  };
}
