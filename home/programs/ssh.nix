{ config, pkgs, lib, ... }:

{
  programs.ssh = {
    enable = true;

    extraConfig = ''
      Protocol 2

      ServerAliveInterval 60
      ServerAliveCountMax 3

      ControlMaster auto
      ControlPath ~/.ssh/sockets/%r@%h-%p
      ControlPersist 600

      Compression yes

      ForwardAgent no
    '';
    
    matchBlocks = {
      # "myserver" = {
      #   hostname = "server.example.com";
      #   user = "ab";
      #   port = 22;
      #   identityFile = "~/.ssh/id_ed25519";
      # };
      
      # "github" = {
      #   hostname = "github.com";
      #   user = "git";
      #   identityFile = "~/.ssh/id_ed25519";
      # };
    };
  };
  
  home.file.".ssh/sockets/.keep".text = "";
}
