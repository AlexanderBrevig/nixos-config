{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.media.graphics;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.media.graphics = {
    enable = mkBoolOpt true;
    tools.enable = mkBoolOpt true;
    raster.enable = mkBoolOpt true;
    vector.enable = mkBoolOpt true;
    models.enable = mkBoolOpt true;
    electronics.enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs;
      (if cfg.tools.enable then [
        imagemagick # for image manipulation from the shell
      ] else [ ]) ++

      (if cfg.vector.enable then [
        inkscape
      ] else [ ]) ++

      (if cfg.raster.enable then [
        gimp
      ] else [ ]) ++

      (if cfg.models.enable then [
        blender
      ] else [ ]) ++

      (if cfg.electronics.enable then [
        kicad
      ] else [ ]);
  };
} 