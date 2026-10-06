{
  pkgs,
  lib,
  config,
  username,
  ...
}:

with lib;
let
  cfg = config.modules.hw-dev;

in
{
  options.modules.hw-dev = {
    enable = mkEnableOption "hw-dev";
  };
  config = mkIf cfg.enable {

    services.udev = {
      packages = with pkgs; [
        platformio-core
        openocd
        teensy-udev-rules
      ];
    };
    users.groups."plugdev" = { };
    users.users.${username}.extraGroups = [
      "plugdev"
      "dialout"
    ];

  };

}
