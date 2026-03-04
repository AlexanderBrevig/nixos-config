{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;

    ignores = [
      ".direnv"
      ".claude"
      "CLAUDE.md"
    ];

    settings = {
      user.name = "ab";
      user.email = "alexander.brevig@hey.com";

      core.editor = "hx";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;

      diff.tool = "helix";
      merge.tool = "helix";

      color.ui = "auto";

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
