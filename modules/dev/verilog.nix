{ config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.verilog;
in {
  options.modules.dev.verilog = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        verilog
        svls
      ];
    })

    (mkIf cfg.xdg.enable {
      # TODO
    })
  ];
}
