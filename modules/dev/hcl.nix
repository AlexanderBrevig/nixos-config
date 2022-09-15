{ config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.hcl;
in {
  options.modules.dev.hcl = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        terraform-ls
      ];
    })

    (mkIf cfg.xdg.enable {
      # TODO
    })
  ];
}
