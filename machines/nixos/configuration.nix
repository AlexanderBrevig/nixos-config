{ pkgs, ... }:

let
  dirs = {
    defaults = ../../defaults;
  };
  configs = {
    dnscrypt-proxy2 = import (dirs.defaults + /dnscrypt-proxy2);
  };
in
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  networking = {
    hostName = "nixos";

    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp2s0.useDHCP = true;

    hosts = import (dirs.defaults + /hosts);
  };

  security.pam.loginLimits = [{ domain = "*"; type = "soft"; item = "nofile"; value = "8192"; }];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
