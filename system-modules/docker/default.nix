{
  pkgs,
  lib,
  config,
  username,
  ...
}:
with lib; let
  cfg = config.modules.docker;
in {
  options.modules.docker = {enable = mkEnableOption "docker";};
  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      daemon.settings = {
        features.cdi = false;
        # debug = true;
      };
    };

    users.users.${username}.extraGroups = ["docker"];
  };
}
