# Shared configuration for both hosts
{ config, pkgs, lib, inputs, ... }:

{
  # Boot configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    
    # Enable latest kernel for better hardware support
    kernelPackages = pkgs.linuxPackages_latest;
  };

  # Networking
  networking = {
    networkmanager.enable = true;
    
    # Basic firewall configuration
    firewall = {
      enable = true;
      allowedTCPPorts = [ 
        22    # SSH
        # 80    # HTTP (uncomment if needed)
        # 443   # HTTPS (uncomment if needed)
        # 8080  # Development servers (uncomment if needed)
      ];
      allowedUDPPorts = [ ];
    };
  };

  # Localization - English with Norwegian locale for dates/money/etc
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

  # User account
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
      "input"    # For Hyprland input devices
      "render"   # For Hyprland GPU access
    ];
    shell = pkgs.fish;
  };

  # Enable fish globally
  programs.fish.enable = true;

  # Security and hardware
  security = {
    rtkit.enable = true;  # RealtimeKit for audio
    polkit.enable = true;
  };

  # Hardware support
  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    pulseaudio.enable = false; # We'll use pipewire instead
  };

  # Audio with PipeWire (better for modern desktop)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # System services
  services = {
    # D-Bus for desktop integration
    dbus.enable = true;
    
    # Printing support
    printing.enable = true;
    
    # SSH server
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;  # Only allow key-based auth
        PermitRootLogin = "no";         # Disable root login
        X11Forwarding = true;           # Allow X11 forwarding
      };
      # Uncomment and add your public keys:
      # users.ab.openssh.authorizedKeys.keys = [
      #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... your-key-here"
      # ];
    };

    # Automatic garbage collection
    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
      
      # Flakes and nix command
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
      };
    };
    
    # Power management
    power-profiles-daemon.enable = true;

    # Location services for time zone detection
    geoclue2.enable = true;

    # Fail2ban for SSH brute-force protection
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
        # Add your trusted IP ranges here, e.g.:
        # "192.168.1.0/24"
      ];
    };
  };

  # System packages available to all users
  # Keep minimal - only emergency/recovery essentials
  # User tools belong in home-manager for proper integration
  environment.systemPackages = with pkgs; [
    # Bare essentials for emergency recovery
    vim
    git
    wget
    
    # Archive utilities for emergency file operations
    unzip
    zip
    
    # File system support
    ntfs3g
    exfat
  ];

  # Docker container runtime
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    # Automatically prune old containers, images, and volumes
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken.
  system.stateVersion = "24.11";
}