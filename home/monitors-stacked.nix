{ ... }:

{
  # Place external monitors side by side at the top, laptop centered below
  wayland.windowManager.hyprland.extraConfig = ''
    local function layout_monitors(removed)
      local exts, edp = {}, nil
      for _, m in ipairs(hl.get_monitors()) do
        if m.name == "eDP-1" then
          edp = m
        elseif m.name ~= removed then
          table.insert(exts, m)
        end
      end
      if #exts == 0 or not edp then
        return
      end

      local x, max_h = 0, 0
      for _, m in ipairs(exts) do
        hl.monitor({ output = m.name, mode = "preferred", position = x .. "x0", scale = 1 })
        x = x + m.width
        max_h = math.max(max_h, m.height)
      end

      local offset = math.abs(x - edp.width) // 2
      hl.monitor({ output = "eDP-1", mode = "preferred", position = offset .. "x" .. max_h, scale = 1 })
    end

    hl.on("hyprland.start", function() layout_monitors() end)
    hl.on("monitor.added", function() layout_monitors() end)
    hl.on("monitor.removed", function(m) layout_monitors(m.name) end)
  '';
}
