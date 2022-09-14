{ pkgs, config, lib, ... }:
{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];

  ## Modules
  modules = {
    desktop = {
      sway.enable = true;
      term = {
        default = "kitty";
      };
      vm = {
        qemu.enable = true;
      };
    };
    dev = {
      node.enable = true;
      rust.enable = true;
      python.enable = true;
    };
    editors = {
      default = "nvim";
    };
    shell = {
      direnv.enable = true;
      git.enable    = true;
      gnupg.enable  = true;
    };
    services = {
      ssh.enable = true;
      docker.enable = true;
    };
  };


  ## Local config
  programs.ssh.startAgent = true;
  programs.fish = {
    enable = true;
  };
  programs.starship = {
    enable = true;
  };
  services.openssh.startWhenNeeded = true;

  networking.networkmanager.enable = true;
}
