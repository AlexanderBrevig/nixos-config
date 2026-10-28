{ pkgs, lib, ... }:

let
  # Plugin formats and the subdirectory they install into under a profile's lib/.
  formats = {
    LV2_PATH = "lv2";
    VST3_PATH = "vst3";
    CLAP_PATH = "clap";
    VST_PATH = "vst";
    LADSPA_PATH = "ladspa";
    DSSI_PATH = "dssi";
  };

  # User dir first (manual installs), then HM user profile, then system profile.
  searchPath = dir: [
    "$HOME/.${dir}"
    "/etc/profiles/per-user/$USER/lib/${dir}"
    "/run/current-system/sw/lib/${dir}"
  ];

  # REAPER ignores LV2_PATH/VST3_PATH (only CLAP_PATH is honoured), so its
  # scan paths are written into reaper.ini. ';'-separated, '~' is expanded.
  reaperPath = dir: lib.concatStringsSep ";" [
    "~/.${dir}"
    "/etc/profiles/per-user/ab/lib/${dir}"
    "/run/current-system/sw/lib/${dir}"
  ];
  reaperIniKeys = {
    lv2path_linux = reaperPath "lv2";
    vstpath = "${reaperPath "vst"};${reaperPath "vst3"}";
  };
  sedArgs = lib.concatStringsSep " " (lib.mapAttrsToList (k: v:
    "-e '/^\\[reaper\\]/,/^\\[/{/^${k}=/d}' -e '/^\\[reaper\\]/a ${k}=${v}'"
  ) reaperIniKeys);
in
{
  environment.systemPackages = with pkgs; [
    # Drums
    x42-avldrums # AVL Drumkits (LV2, samples bundled)
    drumgizmo # LV2; kits are separate downloads (drumgizmo.org/wiki/doku.php?id=kits)

    # Synths
    surge-xt # LV2/VST3/CLAP, factory patches bundled

    # Guitar
    neural-amp-modeler-lv2 # no models bundled; load .nam captures
    lsp-plugins # IR loader for cab sims, plus EQ/comp/gate
  ];

  environment.sessionVariables = lib.mapAttrs (_: searchPath) formats;

  # REAPER rewrites reaper.ini on exit, so this is re-applied on every switch.
  home-manager.users.ab = { lib, ... }: {
    home.activation.reaperPluginPaths = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ini="$HOME/.config/REAPER/reaper.ini"
      if [ -f "$ini" ]; then
        run ${pkgs.gnused}/bin/sed -i ${sedArgs} "$ini"
      fi
    '';
  };
}
