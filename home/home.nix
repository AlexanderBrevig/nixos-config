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
    just
    cmake
    gnumake
    gcc
    clang-tools

    rust-analyzer
    gopls
    pyright

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

    slack
    discord

    spotify

    kicad
    blender
    inkscape
    gimp
    # freecad  # TODO: broken in nixpkgs (boost issue)

    docker-compose
    kubectl
    terraform
    claude-code

    ranger
    fzf
    tree
    htop
    btop

    ffmpeg
    imagemagick

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

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

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
  };
}
