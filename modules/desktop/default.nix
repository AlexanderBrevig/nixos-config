{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop;
in
{
  config.user.packages = with pkgs; [
    google-chrome

    # DevOps
    kubectl
    kubectx
    google-cloud-sdk
    cloud-sql-proxy
    kubernetes-helm

    # Quality of life
    fzf
    bat
    exa
    peco
    jq
    yq

    # Tools and utils
    bitwarden
    bitwarden-cli
    taskwarrior
    xdg-utils
    aspell
    aspellDicts.en
    aspellDicts.nb

    # Comms and media
    slack
    element-desktop
    spotify
  ];

  config = {
    home.configFile = {
      ".aspell.conf".text = "data-dir ${pkgs.aspell}/lib/aspell";
    };
  };

  config.fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      jetbrains-mono
      (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" ]; })
      dejavu_fonts
      symbola
    ];
  };
}
