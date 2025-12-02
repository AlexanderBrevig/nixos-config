{ config, pkgs, lib, inputs, ... }:

{
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
    ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    pulseaudio.enable = false;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services = {
    dbus.enable = true;
    
    printing.enable = true;
    
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        X11Forwarding = true;
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
  ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  system.stateVersion = "25.05";
}
