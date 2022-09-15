{ config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.kotlin;
in {
  options.modules.dev.kotlin = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        kotlin
        jdk
        kotlin-language-server
      ];
    })

    (mkIf cfg.xdg.enable {
      # TODO
    })
  ];
}
