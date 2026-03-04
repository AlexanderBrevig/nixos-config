{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        margin-top = 2;
        margin-bottom = 0;
        margin-left = 10;
        margin-right = 10;
        spacing = 4;

        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "hyprland/language" "backlight" "pulseaudio" "network" "cpu" "memory" "battery" "tray" ];

        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "0";
          };
          on-click = "activate";
          sort-by-number = true;
        };

        clock = {
          format = "󰥔  {:%a %b %d  %H:%M}";
          format-alt = "󰥔  {:%Y-%m-%d  %H:%M:%S}";
          interval = 1;
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };

        "hyprland/language" = {
          format = "󰌌  {}";
          format-en = "EN";
          format-no = "NO";
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = [ "󰃞" "󰃟" "󰃠" ];
          tooltip = false;
        };

        cpu = {
          format = "󰍛  {usage}%";
          tooltip = true;
          interval = 2;
        };

        memory = {
          format = "󰘚  {}%";
          interval = 2;
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-charging = "󰂄  {capacity}%";
          format-plugged = "󰚥  {capacity}%";
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        };

        network = {
          format-wifi = "󰤨  {signalStrength}%";
          format-ethernet = "󰈀  {ipaddr}";
          format-disconnected = "󰤭  off";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}\n{essid}";
          on-click = "nm-connection-editor";
        };

        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = "󰖁  mute";
          format-icons = {
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          on-click = "pavucontrol";
        };

        tray = {
          spacing = 8;
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrains Mono Nerd Font", "JetBrains Mono", "Font Awesome 6 Free";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
        color: #cdd6f4;
      }

      tooltip {
        background: #1e1e2e;
        border: 1px solid #45475a;
        border-radius: 10px;
      }

      tooltip label {
        color: #cdd6f4;
      }

      /* ---- Left ---- */

      #workspaces {
        background: #1e1e2e;
        border-radius: 12px;
        padding: 0 4px;
        margin: 2px 0;
      }

      #workspaces button {
        padding: 0 6px;
        color: #6c7086;
        background: transparent;
        border: none;
        border-radius: 10px;
        min-width: 20px;
        transition: all 0.2s ease;
      }

      #workspaces button.active {
        color: #1e1e2e;
        background: #cba6f7;
        border-radius: 10px;
      }

      #workspaces button:hover {
        color: #cdd6f4;
        background: #45475a;
        border-radius: 10px;
      }

      /* ---- Center ---- */

      #clock {
        background: #1e1e2e;
        color: #f9e2af;
        border-radius: 12px;
        padding: 0 14px;
        margin: 2px 0;
        font-weight: bold;
      }

      /* ---- Right modules ---- */

      #language,
      #backlight,
      #battery,
      #cpu,
      #memory,
      #network,
      #pulseaudio {
        background: #1e1e2e;
        border-radius: 12px;
        padding: 0 12px;
        margin: 2px 2px;
      }

      #language {
        color: #f5c2e7;
      }

      #backlight {
        color: #f9e2af;
      }

      #cpu {
        color: #89b4fa;
      }

      #memory {
        color: #cba6f7;
      }

      #battery {
        color: #a6e3a1;
      }

      #battery.charging {
        color: #94e2d5;
      }

      #battery.warning:not(.charging) {
        color: #fab387;
      }

      #battery.critical:not(.charging) {
        color: #f38ba8;
        animation: blink 1s linear infinite;
      }

      @keyframes blink {
        to { color: #cdd6f4; }
      }

      #network {
        color: #94e2d5;
      }

      #network.disconnected {
        color: #f38ba8;
      }

      #pulseaudio {
        color: #fab387;
      }

      #pulseaudio.muted {
        color: #6c7086;
      }

      #tray {
        background: #1e1e2e;
        border-radius: 12px;
        padding: 0 10px;
        margin: 2px 0;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background: #f38ba8;
        border-radius: 10px;
      }
    '';
  };
}
