{ config, pkgs, ... }:

{
  services.hyprpaper = {
    enable = true;
    settings = { };
  };

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${config.home.homeDirectory}/github.com/gnistlab/meta/banner.png
    wallpaper = ,${config.home.homeDirectory}/github.com/gnistlab/meta/banner.png
  '';
}
