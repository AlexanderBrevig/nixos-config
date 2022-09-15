{ config, options, lib, pkgs,  ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.fish;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.fish = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # user.packages = with pkgs; [
    #   fish
    # ];
    programs.fish.enable = true;
    #TODO: install z

    home.configFile = {
      "fish/config.fish".source = "${configDir}/fish/config.fish";
    };
    
    users.defaultUserShell = pkgs.fish;
    
    env.SHELL = "fish";
    
  };
}
