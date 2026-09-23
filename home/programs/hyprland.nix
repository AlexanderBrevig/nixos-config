{ config, pkgs, lib, inputs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false;
    configType = "lua";

    extraConfig = ''
      local mod = "SUPER"

      hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

      hl.config({
        input = {
          kb_layout = "us,no",
          kb_options = "grp:alt_shift_toggle,caps:escape",
          follow_mouse = 1,
          sensitivity = 0,
          touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
            tap_to_click = true,
          },
        },

        general = {
          gaps_in = 5,
          gaps_out = 10,
          border_size = 2,
          col = {
            active_border = { colors = { "rgba(cba6f7ee)", "rgba(89b4faee)" }, angle = 45 },
            inactive_border = "rgba(45475aaa)",
          },
          layout = "dwindle",
        },

        decoration = {
          rounding = 5,
          blur = {
            enabled = true,
            size = 8,
            passes = 1,
          },
        },

        animations = {
          enabled = true,
        },

        dwindle = {
          preserve_split = true,
        },
      })

      hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

      hl.animation({ leaf = "windows",     enabled = true, speed = 7,  bezier = "myBezier" })
      hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
      hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
      hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "default" })
      hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "default" })
      hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,  bezier = "default" })

      hl.bind(mod .. " + Return", hl.dsp.exec_cmd("wezterm"))
      hl.bind(mod .. " + B", hl.dsp.exec_cmd("wezterm --config 'font_size=20.0' --config 'window_background_opacity=1.0' start"))
      hl.bind(mod .. " + SHIFT + Return", hl.dsp.workspace.toggle_special("terminal"))
      hl.bind(mod .. " + Q", hl.dsp.window.close())
      hl.bind(mod .. " + SHIFT + Q", hl.dsp.exec_cmd([[bash -c 'echo -e "Logout\nCancel" | fuzzel --dmenu -p "Logout? " | grep -q Logout && hyprctl dispatch "hl.dsp.exit()"']]))
      hl.bind(mod .. " + E", hl.dsp.exec_cmd("nautilus"))
      hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mod .. " + SHIFT + P", hl.dsp.window.pseudo())
      hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
      hl.bind(mod .. " + D", hl.dsp.exec_cmd("fuzzel"))

      hl.bind(mod .. " + S", hl.dsp.exec_cmd("flameshot gui"))
      hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy]]))
      hl.bind(mod .. " + P", hl.dsp.exec_cmd("hyprlock"))
      hl.bind(mod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | fuzzel -d | cliphist decode | wl-copy"))

      -- Focus and move windows with arrows and vim keys
      local dirs = {
        left = "left", right = "right", up = "up", down = "down",
        H = "left", L = "right", K = "up", J = "down",
      }
      for key, dir in pairs(dirs) do
        hl.bind(mod .. " + " .. key, hl.dsp.focus({ direction = dir }))
        hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = dir }))
      end

      for i = 1, 10 do
        local key = i % 10
        hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
        hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
      end

      hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

      hl.bind(mod .. " + R", hl.dsp.submap("resize"))
      hl.define_submap("resize", function()
        local steps = {
          right = { 30, 0 }, left = { -30, 0 }, up = { 0, -30 }, down = { 0, 30 },
          L = { 30, 0 }, H = { -30, 0 }, K = { 0, -30 }, J = { 0, 30 },
        }
        for key, s in pairs(steps) do
          hl.bind(key, hl.dsp.window.resize({ x = s[1], y = s[2], relative = true }), { repeating = true })
        end
        hl.bind("escape", hl.dsp.submap("reset"))
        hl.bind("Return", hl.dsp.submap("reset"))
      end)

      local function float(name, class)
        hl.window_rule({ name = name, match = { class = class }, float = true })
      end
      float("pavucontrol", "^(pavucontrol)$")
      float("blueman", "^(blueman-manager)$")
      float("nm-applet", "^(nm-applet)$")
      float("scratchpad", "^(scratchpad)$")

      hl.window_rule({
        name = "flameshot",
        match = { class = "^(flameshot)$" },
        float = true,
        animation = "none",
        move = "0 0",
        pin = true,
        suppress_event = "fullscreen",
      })

      hl.window_rule({
        name = "kicad-floats",
        match = { class = "^(kicad)$", float = true },
        size = "900 700",
        center = true,
      })

      hl.window_rule({
        name = "freecad-dialogs",
        match = { class = "^(org.freecad.FreeCAD)$", title = "negative:^FreeCAD$" },
        float = true,
      })
      hl.window_rule({
        name = "freecad-floats",
        match = { class = "^(org.freecad.FreeCAD)$", float = true },
        center = true,
      })

      hl.on("hyprland.start", function()
        hl.dispatch(hl.dsp.exec_cmd("uwsm app -- wezterm start --class scratchpad", { workspace = "special:terminal silent" }))
        for _, cmd in ipairs({
          "uwsm app -- waybar",
          "uwsm app -- dunst",
          "uwsm app -- nm-applet",
          "uwsm app -- blueman-applet",
          "wl-paste --type text --watch cliphist store",
          "wl-paste --type image --watch cliphist store",
          "uwsm app -- ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1",
        }) do
          hl.dispatch(hl.dsp.exec_cmd(cmd))
        end
      end)
    '';
  };
}
