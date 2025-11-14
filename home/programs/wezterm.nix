# WezTerm terminal configuration
{ config, pkgs, lib, ... }:

{
  programs.wezterm = {
    enable = true;
    
    extraConfig = ''
      local config = {}
      
      -- Font configuration
      config.font = wezterm.font('JetBrains Mono')
      config.font_size = 12.0
      
      -- Color scheme
      config.color_scheme = 'OneDark (base16)'
      
      -- Background
      config.window_background_opacity = 0.95
      
      -- Tabs
      config.enable_tab_bar = true
      config.hide_tab_bar_if_only_one_tab = true
      
      -- Cursor
      config.default_cursor_style = 'BlinkingBar'
      
      -- Scrollback
      config.scrollback_lines = 10000
      
      -- Key bindings
      config.keys = {
        -- Split panes
        {key = 'd', mods = 'CTRL|SHIFT', action = wezterm.action.SplitHorizontal{domain = 'CurrentPaneDomain'}},
        {key = 'd', mods = 'CTRL', action = wezterm.action.SplitVertical{domain = 'CurrentPaneDomain'}},
        
        -- Navigate panes
        {key = 'h', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Left'},
        {key = 'j', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Down'},
        {key = 'k', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Up'},
        {key = 'l', mods = 'CTRL|SHIFT', action = wezterm.action.ActivatePaneDirection 'Right'},
      }
      
      return config
    '';
  };
}