{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./programs/git.nix
    ./programs/fish.nix
    ./programs/helix.nix
    ./programs/starship.nix
    ./programs/wezterm.nix
    ./programs/hyprland.nix
    ./programs/ssh.nix
    ./programs/waybar.nix
    ./programs/fuzzel.nix
  ];

  home = {
    username = "ab";
    homeDirectory = "/home/ab";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    git
    gh
    just

    wezterm
    starship
    zoxide
    bat
    fd
    eza
    ripgrep
    vivid
    jq
    yq-go

    google-chrome

    claude-code
    gemini-cli

    fzf
    tree
    htop
    # btop  # managed by programs.btop

    nmap
    wget
    curl

    p7zip
    unrar

    lshw
    usbutils
    pciutils

    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "never";  # no tray icon (no systray in Hyprland by default)
  };

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "catppuccin_mocha";
      theme_background = false;
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.file.".config/chrome-flags.conf".text = ''
    --ozone-platform=wayland
    --enable-features=VaapiVideoDecoder,VaapiVideoEncoder
    --use-gl=egl
  '';

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "${config.home.homeDirectory}/Desktop";
      documents = "${config.home.homeDirectory}/Documents";
      download = "${config.home.homeDirectory}/Downloads";
      music = "${config.home.homeDirectory}/Music";
      pictures = "${config.home.homeDirectory}/Pictures";
      videos = "${config.home.homeDirectory}/Videos";
      templates = "${config.home.homeDirectory}/Templates";
      publicShare = "${config.home.homeDirectory}/Public";
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "google-chrome.desktop";
        "x-scheme-handler/http" = "google-chrome.desktop";
        "x-scheme-handler/https" = "google-chrome.desktop";
        "x-scheme-handler/about" = "google-chrome.desktop";
        "x-scheme-handler/unknown" = "google-chrome.desktop";
      };
    };
  };
}
