{ config, pkgs, lib, inputs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (final: prev: {
      jetbrains-mono = inputs.nixpkgs-stable.legacyPackages.${prev.stdenv.hostPlatform.system}.jetbrains-mono;
      freecad = inputs.nixpkgs-stable.legacyPackages.${prev.stdenv.hostPlatform.system}.freecad;
    })
  ];
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ ];
    };
  };

  time.timeZone = "Europe/Oslo";
  
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "nb_NO.UTF-8";
      LC_IDENTIFICATION = "nb_NO.UTF-8";
      LC_MEASUREMENT = "nb_NO.UTF-8";
      LC_MONETARY = "nb_NO.UTF-8";
      LC_NAME = "nb_NO.UTF-8";
      LC_NUMERIC = "nb_NO.UTF-8";
      LC_PAPER = "nb_NO.UTF-8";
      LC_TELEPHONE = "nb_NO.UTF-8";
      LC_TIME = "nb_NO.UTF-8";
    };
  };

  users.users.ab = {
    isNormalUser = true;
    description = "ab";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "docker"
      "libvirtd"
      "input"
      "render"
      "dialout"
      "plugdev"
    ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  # Create plugdev group (not default on NixOS)
  users.groups.plugdev = {};

  # Embedded dev: debug probes + RP2040/RP2350 USB access
  services.udev.extraRules = ''
    # Raspberry Pi — all devices (vendor 2e8a):
    #   RP2040/RP2350 BOOTSEL mode, Picoprobe/Debug Probe, CDC serial
    ATTRS{idVendor}=="2e8a", MODE="0666", GROUP="plugdev"
    # CMSIS-DAP compatible probes
    ATTRS{product}=="*CMSIS-DAP*", MODE="0666", GROUP="plugdev"
    # ST-Link
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE="0666", GROUP="plugdev"
    # J-Link
    ATTRS{idVendor}=="1366", MODE="0666", GROUP="plugdev"
  '';

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };

  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  services = {
    dbus.enable = true;
    
    printing.enable = true;

    # Auto-mount USB drives
    udisks2.enable = true;
    gvfs.enable = true;

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        X11Forwarding = true;
      };
    };

    
    power-profiles-daemon.enable = true;

    geoclue2.enable = true;

    fail2ban = {
      enable = true;
      maxretry = 5;
      bantime = "1h";
      bantime-increment = {
        enable = true;
        multipliers = "1 2 4 8 16 32 64";
        maxtime = "168h"; # 1 week
        overalljails = true;
      };
      ignoreIP = [
        "127.0.0.1/8"
        "::1"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    wget

    unzip
    zip

    ntfs3g
    exfat

    freecad
  ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };
  };

  system.stateVersion = "25.11";
}
