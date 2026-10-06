{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.modules.greetd;
in {
  options.modules.greetd = {enable = mkEnableOption "greetd";};
  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = ''${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland -r --asterisks --user-menu --theme border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red'';
          user = "greeter";
        };
      };
    };
  };
}
