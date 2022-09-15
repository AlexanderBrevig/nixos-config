  { config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop;
in {
  config.user.packages = with pkgs; [
    google-chrome

    # DevOps
    kubectl
    kubectx
    google-cloud-sdk
    cloud-sql-proxy
    kubernetes-helm

    # Quality of life
    bat
    exa
    peco
    jq
    yq
    
    # Comms and media
    slack
    element-desktop
    spotify
  ];

  config.fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      jetbrains-mono
      dejavu_fonts
      symbola
    ];
  };
}
