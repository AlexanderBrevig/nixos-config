{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.term;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.term = {
    default = mkOpt types.str "kitty";
    shell = mkOpt types.str "fish";
  };

  config = {
    home.configFile = {
      "kitty/kitty.conf".source = "${configDir}/kitty/kitty.conf";
      "kitty/current-theme.conf".source = "${configDir}/kitty/current-theme.conf";
    };
    env.TERMINAL = cfg.default;
    env.SHELL = cfg.shell;
    env.STARSHIP_SHELL = cfg.shell;
  };
}
