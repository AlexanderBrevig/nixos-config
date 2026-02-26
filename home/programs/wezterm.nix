{ config, pkgs, lib, ... }:

{
  programs.wezterm = {
    enable = true;
    
    extraConfig = ''
      local config = {}

      config.font = wezterm.font('JetBrains Mono')
      config.font_size = 12.0

      config.color_scheme = 'Catppuccin Mocha'

      config.window_background_opacity = 0.95

      config.enable_tab_bar = true
      config.hide_tab_bar_if_only_one_tab = true

      config.default_cursor_style = 'BlinkingBar'

      config.scrollback_lines = 10000

      config.keys = {
        {key = 'd', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal{domain = 'CurrentPaneDomain'}},
        {key = 'd', mods = 'CTRL', action = wezterm.action.SplitVertical{domain = 'CurrentPaneDomain'}},

        {key = 'h', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Left'},
        {key = 'j', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Down'},
        {key = 'k', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Up'},
        {key = 'l', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Right'},
      }

      return config
    '';
  };
}
