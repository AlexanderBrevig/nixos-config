{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors;
    configDir = config.dotfiles.configDir;
in {
  options.modules.editors = {
    default = mkOpt types.str "nvim";
  };

  config = mkIf (cfg.default != null) {
    env.EDITOR = cfg.default;
  	home.configFile = {
  		"helix/config.toml".source = "${configDir}/helix/config.toml";
  		"helix/languages.toml".source = "${configDir}/helix/languages.toml";
  	};
  };

}
