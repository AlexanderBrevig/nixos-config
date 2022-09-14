{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.term;
in {
  options.modules.desktop.term = {
    default = mkOpt types.str "kitty";
  };

  config = {
    env.TERMINAL = cfg.default;
  };
}
