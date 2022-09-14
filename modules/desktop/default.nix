{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop;
in {
  config.user.packages = with pkgs; [
    google-chrome
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
