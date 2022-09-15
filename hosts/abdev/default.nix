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
      nix.enable = true;
      rust.enable = true;
      cc.enable = true;
      go.enable = true;
      common-lisp.enable = true;
      haskell.enable = true;
      hcl.enable = true;
      node.enable = true;
      typescript.enable = true;
      python.enable = true;
      scala.enable = true;
      kotlin.enable = true;
      java.enable = true;
      verilog.enable = true;
      shell.enable = true;
      toml.enable = true;
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
