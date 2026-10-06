{
  pkgs,
  lib,
  config,
  username,
  ...
}:
with lib; let
  cfg = config.modules.via;
in {
  options.modules.via = {enable = mkEnableOption "via";};
  config = mkIf cfg.enable {
    #environment.systemPackages = with pkgs; [ ];
    users.users.${username}.extraGroups = ["plugdev"];
    services.udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", GROUP="plugdev", MODE="0660"
    '';
  };
}
