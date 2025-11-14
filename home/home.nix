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
    # Core development tools (always available)
    git
    just           # Build tool
    cmake
    gnumake
    
    # Stable language toolchains (for general development)
    rustc
    cargo
    rust-analyzer  # Keep for editor integration
    rustfmt
    clippy
    
    go
    gopls         # Keep for editor integration
    gofumpt
    
    # System languages (rarely change versions)
    gcc
    clang
    
    # Python (system default, projects can override)
    python3
    python3Packages.pip
    python3Packages.virtualenv
    
    # Optional: Keep if you use these frequently across projects
    # openjdk21    # Move to project flakes if you need different versions
    # gradle       # Move to project flakes
    # maven        # Move to project flakes
    # flutter      # Move to project flakes  
    # dart         # Move to project flakes
    # ocaml        # Move to project flakes
    # dune_3       # Move to project flakes
    # ocaml-lsp    # Move to project flakes
    
    # Terminal tools  
    wezterm
    starship
    zoxide
    bat           # batcat as cat
    fd            # fdfind as fd  
    eza           # modern ls
    ripgrep       # rg
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