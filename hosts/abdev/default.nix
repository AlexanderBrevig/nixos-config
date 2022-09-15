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
        shell = "fish";
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
      default = "hx";
    };
    shell = {
      direnv.enable = true;
      git.enable    = true;
      gnupg.enable  = true;
      fish.enable   = true;
      starship.enable = true;
    };
    services = {
      ssh.enable = true;
      docker.enable = true;
    };
  };


  ## Local config
  programs.ssh.startAgent = true;
  services = {
    openssh.startWhenNeeded = true;
    getty.autologinUser = config.user.name;
  };

  networking.networkmanager.enable = true;
}
