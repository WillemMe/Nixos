{ pkgs, lib, config, ... }:

with lib;
let 
    cfg = config.modules.scripts;
    screen = pkgs.writeShellScriptBin "screen" ''${builtins.readFile ./screen}'';
    bandw = pkgs.writeShellScriptBin "bandw" ''${builtins.readFile ./bandw}'';
    maintenance = pkgs.writeShellScriptBin "maintenance" ''${builtins.readFile ./maintenance}'';
    rofi-power-menu = pkgs.writeShellScriptBin "rofi-power-menu" ''${builtins.readFile ./rofi-power-menu}'';
    rebuild = writeShellScriptBin "build" ''${builtins.readFile ./build.sh}'';
in {
    options.modules.scripts = { enable = mkEnableOption "scripts"; };
    config = mkIf cfg.enable {
        home.packages = [
          maintenance rofi-power-menu build
        ];
    };
}
