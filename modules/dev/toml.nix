{ config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.toml;
in {
  options.modules.dev.toml = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        taplo
        toml2json
      ];
    })

    (mkIf cfg.xdg.enable {
      # TODO
    })
  ];
}
