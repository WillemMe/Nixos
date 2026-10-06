{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.noctalia;
in
{
  imports = [ inputs.noctalia.nixosModules.default ];

  options.modules.noctalia = {
    enable = mkEnableOption "noctalia";
  };

  config = mkIf cfg.enable {
    programs.noctalia = {
      enable = true;
      # networking.networkmanager / hardware.bluetooth are already enabled
      # elsewhere in this config; this also turns on the power-profiles-daemon
      # and upower services that were missing.
      recommendedServices.enable = true;
      systemd.enable = true;
    };
  };
}
