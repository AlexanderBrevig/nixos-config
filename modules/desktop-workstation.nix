{ pkgs, lib, ... }:

let
  obs-nvidia = pkgs.symlinkJoin {
    name = "obs-studio-nvidia";
    paths = [
      (pkgs.wrapOBS {
        plugins = with pkgs.obs-studio-plugins; [
          obs-vkcapture
        ];
      })
    ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/obs \
        --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib
    '';
  };
in
{
  # Low-latency audio for production work
  # Keys must be quoted: PipeWire wants flat dotted keys, and unquoted Nix
  # attr paths render as nested JSON objects that PipeWire silently ignores.
  # Desktop apps run at 1024; a JACK client (REAPER) pulls the graph down to
  # its own buffer size, as low as min-quantum.
  services.pipewire.extraConfig.pipewire."92-low-latency" = {
    "context.properties" = {
      "default.clock.rate" = 48000;
      "default.clock.allowed-rates" = [ 48000 ];
      "default.clock.quantum" = 1024;
      "default.clock.min-quantum" = 32;
      "default.clock.max-quantum" = 2048;
    };
  };

  # JACK clients (REAPER) have no buffer-size control under PipeWire; make
  # them request 128 frames (~2.7 ms) so the graph drops while they run.
  services.pipewire.extraConfig.jack."92-low-latency" = {
    "jack.properties" = {
      "node.latency" = "128/48000";
    };
  };

  environment.systemPackages = with pkgs; [
    # Default libjack2 looks for a jackd server; use PipeWire's JACK instead.
    (reaper.override { jackLibrary = pipewire.jack; })
    obs-nvidia
    kdePackages.kdenlive
    wf-recorder
    flameshot
  ];
}
