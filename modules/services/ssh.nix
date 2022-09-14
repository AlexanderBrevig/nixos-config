{ options, config, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      kbdInteractiveAuthentication = false;
      passwordAuthentication = false;
    };

    user.openssh.authorizedKeys.keys =
      if config.user.name == "alexander"
      then [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA/9A8Zsddng2E/vnfylRWO7kTge8vpVZkNdGjRraF6O alexander@abdev" ]
      else [];
  };
}
