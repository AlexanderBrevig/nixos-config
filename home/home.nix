# Home Manager configuration
{ config, pkgs, lib, inputs, ... }:

{
  # Import program-specific configurations
  imports = [
    ./programs/git.nix
    ./programs/fish.nix
    ./programs/helix.nix
    ./programs/starship.nix
    ./programs/wezterm.nix
    ./programs/hyprland.nix
    ./programs/ssh.nix
  ];

  # Basic user info
  home = {
    username = "ab";
    homeDirectory = "/home/ab";
    stateVersion = "24.11";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Development tools and applications
  home.packages = with pkgs; [
    # Core build tools (system-level)
    git
    just           # Build tool
    cmake
    gnumake
    gcc            # System C compiler
    clang          # System C/C++ compiler

    # Language servers for editor integration (per-project toolchains via flakes)
    rust-analyzer  # Rust LSP
    gopls          # Go LSP
    pyright        # Python LSP
    # Add other LSPs as needed for your editor
    
    # Terminal tools
    wezterm
    starship
    zoxide
    bat           # batcat as cat
    fd            # fdfind as fd
    eza           # modern ls
    ripgrep       # rg
    vivid         # LS_COLORS theme generator
    jq
    yq-go
    
    # Web browsers
    google-chrome
    
    # Communication
    slack
    discord
    
    # Media
    spotify
    
    # Design and CAD
    kicad
    blender
    inkscape
    gimp
    freecad
    
    # Claude desktop (if available, otherwise use web version)
    # Add when available in nixpkgs
    
    # Additional development tools
    docker-compose
    kubectl
    terraform
    
    # File managers and utilities
    ranger
    fzf
    tree
    htop
    btop
    
    # Media tools
    ffmpeg
    imagemagick
    
    # Network tools
    nmap
    wget
    curl
    
    # Archive tools
    p7zip
    unrar
    
    # System utilities
    lshw
    usbutils
    pciutils
    
    # Fonts
    nerdfonts
  ];











  # Direnv for project-specific environments
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };





  # XDG user directories
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