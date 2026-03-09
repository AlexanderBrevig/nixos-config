{ config, pkgs, lib, inputs, ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;

    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
    ];

    config = {
      common = {
        default = ["gtk"];
        "org.freedesktop.impl.portal.Screencast" = ["hyprland"];
        "org.freedesktop.impl.portal.Screenshot" = ["hyprland"];
      };
      hyprland.default = ["hyprland" "gtk"];
    };

  };

  environment.systemPackages = with pkgs; [
    hyprpaper
    hyprlock
    hypridle
    hyprpicker

    dunst
    libnotify

    fuzzel
    waybar
  ];
}
