{ config, pkgs, lib, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        extraOptions = {
          Protocol = "2";
          ServerAliveInterval = "60";
          ServerAliveCountMax = "3";
          ControlMaster = "auto";
          ControlPath = "~/.ssh/sockets/%r@%h-%p";
          ControlPersist = "600";
          Compression = "yes";
        };
        forwardAgent = false;
      };
    };
  };
  
  home.file.".ssh/sockets/.keep".text = "";
}
