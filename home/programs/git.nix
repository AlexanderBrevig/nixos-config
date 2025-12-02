{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    userName = "ab";
    userEmail = "alexander.brevig@hey.com";
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      
      diff.tool = "helix";
      merge.tool = "helix";
      
      color.ui = "auto";
      
      # TODO: move over old dotfile
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
