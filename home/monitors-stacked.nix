{ pkgs, ... }:

let
  jq = "${pkgs.jq}/bin/jq";

  monitorLayout = pkgs.writeShellScript "monitor-layout" ''
    monitors=$(hyprctl monitors -j)
    ext_count=$(echo "$monitors" | ${jq} '[.[] | select(.name != "eDP-1")] | length')

    if (( ext_count >= 1 )); then
      max_ext_height=$(echo "$monitors" | ${jq} '[.[] | select(.name != "eDP-1") | .height] | max')
      total_ext_width=$(echo "$monitors" | ${jq} '[.[] | select(.name != "eDP-1") | .width] | add')
      edp_width=$(echo "$monitors" | ${jq} -r '.[] | select(.name == "eDP-1") | .width')

      # Place externals side by side at the top
      x=0
      for ext_name in $(echo "$monitors" | ${jq} -r '.[] | select(.name != "eDP-1") | .name'); do
        hyprctl keyword monitor "$ext_name, preferred, ''${x}x0, 1"
        ext_w=$(echo "$monitors" | ${jq} -r ".[] | select(.name == \"$ext_name\") | .width")
        x=$((x + ext_w))
      done

      # Center laptop below the externals
      if (( total_ext_width >= edp_width )); then
        offset=$(( (total_ext_width - edp_width) / 2 ))
      else
        offset=$(( (edp_width - total_ext_width) / 2 ))
      fi
      hyprctl keyword monitor "eDP-1, preferred, ''${offset}x''${max_ext_height}, 1"
    fi
  '';

  monitorListener = pkgs.writeShellScript "monitor-listener" ''
    sleep 1
    ${monitorLayout}

    ${pkgs.socat}/bin/socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
      case "$line" in
        monitoradded*|monitorremoved*)
          sleep 1
          ${monitorLayout}
          ;;
      esac
    done
  '';
in
{
  wayland.windowManager.hyprland.settings.exec-once = [
    "${monitorListener}"
  ];
}
