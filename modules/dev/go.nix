{ config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.go;
in {
  options.modules.dev.go = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        go
        gopls
      ];
    })

    (mkIf cfg.xdg.enable {
      # TODO
    })
  ];
}
