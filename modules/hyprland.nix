{ config, pkgs, lib, inputs, ... }:

{
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];

    config = {
      common = {
        default = ["gtk"];
        "org.freedesktop.impl.portal.Screencast" = ["hyprland"];
        "org.freedesktop.impl.portal.Screenshot" = ["hyprland"];
      };
      hyprland.default = ["hyprland" "gtk"];
    };

    xdgOpenUsePortal = true;
  };

  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    dbus.enable = true;
  };

  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
  };

  environment = {
    sessionVariables = {
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_CURRENT_DESKTOP = "Hyprland";

      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      GDK_BACKEND = "wayland,x11";
      CLUTTER_BACKEND = "wayland";
      SDL_VIDEODRIVER = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      MOZ_ENABLE_WAYLAND = "1";
      LIBVA_DRIVER_NAME = "iHD";
    } // (lib.optionalAttrs (config.services.xserver.videoDrivers or [] == ["nvidia"]) {
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";
    });

    systemPackages = with pkgs; [
      wayland
      wayland-protocols
      wayland-utils
      wl-clipboard
      wlr-randr

      hyprpaper
      hyprlock
      hypridle
      cliphist
      polkit_gnome
      hyprpicker

      dunst
      libnotify

      fuzzel
      waybar

      wf-recorder
      grim
      slurp
      flameshot

      nautilus
      networkmanagerapplet
      blueman
      pavucontrol
      brightnessctl
      btop
      imv
      mpv
      zathura
    ];
  };

  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      liberation_ttf
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji

      fira-code
      fira-code-symbols
      jetbrains-mono

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

  services.pipewire.extraConfig.pipewire."92-low-latency" = {
    context.properties = {
      default.clock.rate = 48000;
      default.clock.quantum = 32;
      default.clock.min-quantum = 32;
      default.clock.max-quantum = 32;
    };
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
  '';
}