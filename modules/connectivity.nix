{ pkgs, ... }:

{
  services.tailscale.enable = true;

  networking.firewall = {
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [
      41641       # tailscale
    ];
    allowedUDPPortRanges = [
      { from = 60000; to = 61000; }  # mosh
    ];
  };

  environment.systemPackages = with pkgs; [
    mosh
  ];
}
