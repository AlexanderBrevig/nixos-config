{ config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.nix;
in {
  options.modules.dev.nix = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        rnix-lsp
      ];
    })

    (mkIf cfg.xdg.enable {
      # TODO
    })
  ];
}
