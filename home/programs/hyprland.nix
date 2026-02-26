{ config, pkgs, lib, inputs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    
    settings = {
      monitor = [
        ",preferred,auto,1"
      ];

      input = {
        kb_layout = "us,no";
        kb_options = "grp:alt_shift_toggle,caps:escape";
        follow_mouse = 1;
        
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          tap-to-click = true;
        };

        sensitivity = 0;
      };

      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(cba6f7ee) rgba(89b4faee) 45deg";
        "col.inactive_border" = "rgba(45475aaa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 5;

        blur = {
          enabled = true;
          size = 8;
          passes = 1;
        };
      };

      animations = {
        enabled = true;
        
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      bind = [
        "SUPER, Return, exec, wezterm"
        "SUPER SHIFT, Return, togglespecialworkspace, terminal"
        "SUPER, Q, killactive"
        "SUPER SHIFT, Q, exec, bash -c 'echo -e \"Logout\\nCancel\" | fuzzel --dmenu -p \"Logout? \" | grep -q Logout && hyprctl dispatch exit'"
        "SUPER, E, exec, nautilus"
        "SUPER, V, togglefloating"
        "SUPER, F, fullscreen"
        "SUPER, Space, exec, fuzzel"

        "SUPER, S, exec, flameshot gui"
        "SUPER SHIFT, S, exec, grim -g \"$(slurp)\" - | wl-copy"
        "SUPER, P, exec, hyprlock"
        "SUPER SHIFT, V, exec, cliphist list | fuzzel -d | cliphist decode | wl-copy"

        # Focus with arrows and vim keys
        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"
        "SUPER, H, movefocus, l"
        "SUPER, L, movefocus, r"
        "SUPER, K, movefocus, u"
        "SUPER, J, movefocus, d"

        # Move windows with arrows and vim keys
        "SUPER SHIFT, left, movewindow, l"
        "SUPER SHIFT, right, movewindow, r"
        "SUPER SHIFT, up, movewindow, u"
        "SUPER SHIFT, down, movewindow, d"
        "SUPER SHIFT, H, movewindow, l"
        "SUPER SHIFT, L, movewindow, r"
        "SUPER SHIFT, K, movewindow, u"
        "SUPER SHIFT, J, movewindow, d"

        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      windowrule = [
        "float on, match:class ^(pavucontrol)$"
        "float on, match:class ^(blueman-manager)$"
        "float on, match:class ^(nm-applet)$"
        "float on, match:class ^(flameshot)$"

        "float on, match:class ^(scratchpad)$"
      ];

      exec-once = [
        "[workspace special:terminal silent] wezterm start --class scratchpad"
        "waybar > /dev/null 2>&1"
        "dunst"
        "hyprpaper"
        "nm-applet"
        "blueman-applet"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "/run/current-system/sw/libexec/polkit-gnome-authentication-agent-1"
      ];
    };
  };
}
