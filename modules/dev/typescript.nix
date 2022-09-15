{ config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.typescript;
in {
  options.modules.dev.typescript = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        nodePackages.typescript
        nodePackages.typescript-language-server
      ];
    })

    (mkIf cfg.xdg.enable {
      # TODO
    })
  ];
}
