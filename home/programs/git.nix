# Git configuration
{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    userName = "ab";
    userEmail = "your-email@example.com"; # Update this
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      
      # Better diff and merge tools
      diff.tool = "helix";
      merge.tool = "helix";
      
      # Signing (uncomment and configure if you use GPG)
      # commit.gpgsign = true;
      # user.signingkey = "YOUR_GPG_KEY_ID";
      
      # Color output
      color.ui = "auto";
      
      # Aliases for common commands
      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        ca = "commit -a";
        cm = "commit -m";
        cam = "commit -am";
        lg = "log --oneline --graph --all";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        visual = "!gitk";
      };
    };
  };
}