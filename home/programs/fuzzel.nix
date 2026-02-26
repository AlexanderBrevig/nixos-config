{ config, pkgs, lib, ... }:

{
  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        font = "JetBrains Mono:size=12";
        terminal = "wezterm";
        layer = "overlay";
        prompt = "❯ ";
      };

      colors = {
        # Catppuccin Mocha
        background = "1e1e2edd";
        text = "cdd6f4ff";
        match = "f38ba8ff";
        selection = "585b70ff";
        selection-text = "cdd6f4ff";
        selection-match = "f38ba8ff";
        border = "cba6f7ff";
      };

      border = {
        width = 2;
        radius = 8;
      };
    };
  };
}
