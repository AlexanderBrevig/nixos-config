{ config, pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 8;

        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "network" "cpu" "memory" "battery" "tray" ];

        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
        };

        "hyprland/window" = {
          max-length = 50;
          separate-outputs = true;
        };

        clock = {
          format = "{:%Y-%m-%d %H:%M}";
          format-alt = "{:%A, %B %d, %Y (%R)}";
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

        cpu = {
          format = "CPU {usage}%";
          tooltip = true;
          interval = 2;
        };

        memory = {
          format = "MEM {}%";
          interval = 2;
        };

        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "BAT {capacity}%";
          format-charging = "CHG {capacity}%";
          format-plugged = "PLG {capacity}%";
          format-icons = [ "" "" "" "" "" ];
        };

        network = {
          format-wifi = "WIFI {signalStrength}%";
          format-ethernet = "ETH {ipaddr}";
          format-disconnected = "NET off";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}\n{essid}";
          on-click = "nm-connection-editor";
        };

        pulseaudio = {
          format = "VOL {volume}%";
          format-muted = "MUTE";
          on-click = "pavucontrol";
        };

        tray = {
          spacing = 10;
        };
      };
    };

    style = ''
      * {
        font-family: "JetBrains Mono", "Font Awesome 6 Free";
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(30, 30, 46, 0.9);
        color: #cdd6f4;
      }

      #workspaces button {
        padding: 0 8px;
        color: #6c7086;
        background: transparent;
        border: none;
        border-radius: 0;
      }

      #workspaces button.active {
        color: #cdd6f4;
        background: #45475a;
        border-radius: 4px;
      }

      #workspaces button:hover {
        background: #313244;
        border-radius: 4px;
      }

      #window {
        padding: 0 10px;
        color: #a6adc8;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #tray {
        padding: 0 10px;
        margin: 4px 2px;
        background: #313244;
        border-radius: 4px;
      }

      #clock {
        color: #f9e2af;
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
      }

      #cpu {
        color: #89b4fa;
      }

      #memory {
        color: #cba6f7;
      }

      #network {
        color: #94e2d5;
      }

      #network.disconnected {
        color: #f38ba8;
      }

      #pulseaudio {
        color: #f9e2af;
      }

      #pulseaudio.muted {
        color: #6c7086;
      }

      #tray {
        background: transparent;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background: #f38ba8;
      }
    '';
  };
}
