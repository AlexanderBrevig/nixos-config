# SSH client configuration
{ config, pkgs, lib, ... }:

{
  programs.ssh = {
    enable = true;
    
    # SSH client configuration
    extraConfig = ''
      # Security settings
      Protocol 2
      
      # Connection settings
      ServerAliveInterval 60
      ServerAliveCountMax 3
      
      # Speed up connections
      ControlMaster auto
      ControlPath ~/.ssh/sockets/%r@%h-%p
      ControlPersist 600
      
      # Enable compression
      Compression yes
      
      # Forward agent (be careful with this on untrusted hosts)
      ForwardAgent no
    '';
    
    # Example host configurations (uncomment and customize as needed)
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
  
  # Create SSH socket directory
  home.file.".ssh/sockets/.keep".text = "";
}