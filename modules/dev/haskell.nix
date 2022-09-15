{ config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.haskell;
in {
  options.modules.dev.haskell = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        ghc
        haskell-language-server
      ];
    })

    (mkIf cfg.xdg.enable {
      # TODO
    })
  ];
}
