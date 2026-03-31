{ pkgs, ... }:

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
    obs-studio
    kdePackages.kdenlive
    wf-recorder
    flameshot
  ];
}
