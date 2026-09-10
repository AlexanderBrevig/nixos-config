{ config, pkgs, lib, ... }:

{
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = "abthin";

  boot.kernelParams = [
    "amd_pstate=active"
  ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        vulkan-validation-layers
        vulkan-tools
      ];
    };

    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableRedistributableFirmware = true;
  };

  services = {
    fwupd.enable = true;
  };

  # dialout: FC/serial access (Betaflight); the embedded-dev groups otherwise
  # live in shared-workstation.nix, which this host does not import.
  users.users.ab.extraGroups = [ "docker" "dialout" ];

  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  environment.systemPackages = with pkgs; [
    # Android development (whatisaidwas): adb; systemd handles device access
    android-tools
    moonlight-qt
    lm_sensors
    powertop
    acpi
    upower
    vulkan-tools
    mesa-demos
  ];

  powerManagement.enable = true;

  # Auto-switch power profile based on AC state: balanced on AC, power-saver on battery.
  services.udev.extraRules = ''
    SUBSYSTEM=="power_supply", KERNEL=="AC", ATTR{online}=="0", RUN+="${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver"
    SUBSYSTEM=="power_supply", KERNEL=="AC", ATTR{online}=="1", RUN+="${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced"
    # STM32 DFU bootloader (Betaflight firmware flashing) — not a tty, so
    # dialout does not cover it
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE="0664", GROUP="dialout", TAG+="uaccess"
  '';

  # Set the right profile at boot based on current AC state.
  systemd.services.power-profile-init = {
    wantedBy = [ "multi-user.target" ];
    after = [ "power-profiles-daemon.service" ];
    requires = [ "power-profiles-daemon.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      if [ "$(cat /sys/class/power_supply/AC/online)" = "1" ]; then
        ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced
      else
        ${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver
      fi
    '';
  };

  networking.networkmanager.wifi = {
    powersave = true;
    scanRandMacAddress = true;
  };

  # Override hardware-configuration.nix swap: use randomEncryption instead of
  # a separate LUKS device that stalls boot waiting for a second passphrase.
  # Trade-off: hibernation (suspend-to-disk) will not work, but this system
  # uses suspend-to-RAM (s2idle) which is unaffected.
  swapDevices = lib.mkForce [
    {
      device = "/dev/disk/by-partuuid/cfd28bfe-a0fe-4aba-8b26-b0fa37f9b2f0";
      randomEncryption.enable = true;
    }
  ];
}
