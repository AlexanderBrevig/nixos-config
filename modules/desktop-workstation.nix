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
  services.pipewire.extraConfig.pipewire."92-low-latency" = {
    context.properties = {
      default.clock.rate = 48000;
      default.clock.quantum = 32;
      default.clock.min-quantum = 32;
      default.clock.max-quantum = 32;
    };
  };

  environment.systemPackages = with pkgs; [
    reaper
    obs-nvidia
    kdePackages.kdenlive
    wf-recorder
    flameshot
  ];
}
