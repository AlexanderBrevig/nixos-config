{ pkgs, ... }:

let
  dirs = { defaults = ../defaults; };
  passwd = import (dirs.defaults + /passwd);
in
{
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nb_NO.utf8";
    LC_IDENTIFICATION = "nb_NO.utf8";
    LC_MEASUREMENT = "nb_NO.utf8";
    LC_MONETARY = "nb_NO.utf8";
    LC_NAME = "nb_NO.utf8";
    LC_NUMERIC = "nb_NO.utf8";
    LC_PAPER = "nb_NO.utf8";
    LC_TELEPHONE = "nb_NO.utf8";
    LC_TIME = "nb_NO.utf8";
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  programs.fish.enable = true;

  # enable xdg portals and pipewire for screensharing in wayland
  services.pipewire.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-wlr xdg-desktop-portal-gtk ];
    gtkUsePortal = true;
  };

  environment.persistence."/nix/persist" = {
    directories = [
      "/etc/nixos"
      "/etc/NetworkManager/system-connections"
      "/var/lib/containers"
      "/var/log"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };

  users.mutableUsers = false;
  users.users.root.initialHashedPassword = passwd.root;
  users.users.alexander = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "wireshark" "docker" ];
    initialHashedPassword = passwd.alexander;
    subUidRanges = [ { count = 100000; startUid = 65536; } ];
    subGidRanges = [ { count = 100000; startGid = 65536; } ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  environment.systemPackages = with pkgs; [
    pavucontrol
    cryptsetup
    ncdu
  ];

  fonts.fonts = with pkgs; [
    jetbrains-mono
    font-awesome
    apple-color-emoji
  ];

  programs.qt5ct.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    # make a `docker` alias for podman
    dockerCompat = true;
    extraPackages = with pkgs; [
      slirp4netns
      fuse-overlayfs
    ];
  };

  # sway/wayland
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # Allow other users like `root` to access directories bind-mounted
  # by impermanence's home-manager integration.
  programs.fuse.userAllowOther = true;

  environment.variables.EDITOR = "hx";

  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';
}
