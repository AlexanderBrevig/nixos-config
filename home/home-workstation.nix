{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Build tools & compilers
    cmake
    gnumake
    gcc
    clang-tools

    # LSP servers
    rust-analyzer
    gopls
    pyright

    # Communication & media
    slack
    discord
    spotify

    # Creative & engineering
    kicad
    blender
    inkscape
    gimp
    # freecad  # TODO: broken in nixpkgs (boost issue)

    # Infrastructure
    docker-compose
    kubectl
    terraform

    # File managers
    thunar
    thunar-volman  # auto-mount USB in Thunar
    ranger

    # Media processing
    ffmpeg
    imagemagick

    # Display management
    nwg-displays
  ];
}
