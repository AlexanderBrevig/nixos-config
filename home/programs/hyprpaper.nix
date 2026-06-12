{ config, pkgs, ... }:

{
  services.hyprpaper = {
    enable = true;
    settings = { };
  };

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    wallpaper {
      monitor =
      path = ${config.home.homeDirectory}/Pictures/moon.png
    }
  '';
}
