# Hyprland configuration with Wayland and screen sharing
{ config, pkgs, lib, inputs, ... }:

{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    # Enable XWayland for legacy X11 apps
    xwayland.enable = true;
  };

  # XDG Desktop Portal for screen sharing and file dialogs
  xdg.portal = {
    enable = true;

    # Use Hyprland and GTK portals
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];

    # Configure portal preferences
    config = {
      common.default = ["hyprland" "gtk"];
      hyprland.default = ["hyprland" "gtk"];
    };
  };

  # Enable required services for Wayland
  services = {
    # Display manager
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };
    
    # D-Bus session
    dbus.enable = true;
  };

  # Security for screen sharing
  security = {
    # Polkit for authentication dialogs
    polkit.enable = true;
    
    # PAM configuration for swaylock/hyprlock
    pam.services.swaylock = {};
  };

  # Environment variables for Wayland
  environment = {
    sessionVariables = {
      # Wayland session type
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_CURRENT_DESKTOP = "Hyprland";
      
      # Qt Wayland support
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      
      # GDK Wayland support  
      GDK_BACKEND = "wayland,x11";
      
      # Clutter Wayland support
      CLUTTER_BACKEND = "wayland";
      
      # SDL Wayland support
      SDL_VIDEODRIVER = "wayland";
      
      # Java AWT Wayland support
      _JAVA_AWT_WM_NONREPARENTING = "1";
      
      # Firefox Wayland
      MOZ_ENABLE_WAYLAND = "1";
      
      # NVIDIA specific (for workstation)
      LIBVA_DRIVER_NAME = "nvidia";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    # Essential Wayland packages
    systemPackages = with pkgs; [
      # Core Wayland tools
      wayland
      wayland-protocols
      wayland-utils
      wl-clipboard
      wlr-randr
      
      # Hyprland ecosystem
      hyprpaper        # Wallpaper
      hyprlock         # Screen locker
      hypridle         # Idle daemon
      hyprpicker       # Color picker
      
      # Notifications
      dunst
      libnotify
      
      # Application launcher
      rofi-wayland
      
      # Status bar
      waybar
      
      # Screen sharing and recording
      wf-recorder      # Screen recording
      grim             # Screenshots
      slurp            # Area selection
      flameshot        # Screenshot tool with annotation
      
      # File manager
      nautilus
      
      # Network management GUI
      networkmanagerapplet
      
      # Bluetooth GUI
      blueman
      
      # Audio control
      pavucontrol
      
      # Brightness control (for laptops)
      brightnessctl
      
      # System monitoring
      btop
      
      # Image viewer
      imv
      
      # Video player
      mpv
      
      # PDF viewer
      zathura
    ];
  };

  # Fonts for better desktop experience
  fonts = {
    packages = with pkgs; [
      # System fonts
      dejavu_fonts
      liberation_ttf
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      
      # Programming fonts
      fira-code
      fira-code-symbols
      jetbrains-mono
      
      # Icon fonts
      font-awesome
      material-design-icons
    ];
    
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "DejaVu Serif" ];
        sansSerif = [ "DejaVu Sans" ];
        monospace = [ "JetBrains Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # PipeWire low-latency configuration for Hyprland (extends shared.nix config)
  services.pipewire.extraConfig.pipewire."92-low-latency" = {
    context.properties = {
      default.clock.rate = 48000;
      default.clock.quantum = 32;
      default.clock.min-quantum = 32;
      default.clock.max-quantum = 32;
    };
  };

  # Enable udev rules for input devices
  services.udev.extraRules = ''
    # Allow users in video group to control brightness
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';
}