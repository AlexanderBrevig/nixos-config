{ config, pkgs, lib, inputs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      freecad = inputs.nixpkgs-stable.legacyPackages.${prev.stdenv.hostPlatform.system}.freecad;
    })
  ];

  users.users.ab.extraGroups = [
    "docker"
    "libvirtd"
    "dialout"
    "plugdev"
    "lp"
  ];

  # Create plugdev group (not default on NixOS)
  users.groups.plugdev = {};

  # Embedded dev: debug probes + RP2040/RP2350 USB access
  services.udev.extraRules = ''
    # Raspberry Pi — all devices (vendor 2e8a):
    #   RP2040/RP2350 BOOTSEL mode, Picoprobe/Debug Probe, CDC serial
    ATTRS{idVendor}=="2e8a", MODE="0666", GROUP="plugdev"
    # CMSIS-DAP compatible probes
    ATTRS{product}=="*CMSIS-DAP*", MODE="0666", GROUP="plugdev"
    # ST-Link
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE="0666", GROUP="plugdev"
    # J-Link
    ATTRS{idVendor}=="1366", MODE="0666", GROUP="plugdev"
  '';

  environment.systemPackages = with pkgs; [
    freecad
  ];

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };
}
