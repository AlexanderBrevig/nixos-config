{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.starship;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.starship = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      starship
    ];

    home.configFile = {
      "starship.toml".source = "${configDir}/starship/starship.toml";
    };
    
    env.STARSHIP_SHELL = "fish";
    env.STARSHIP_CONFIG= "$XDG_CONFIG_HOME/starship.toml";

  };
}
