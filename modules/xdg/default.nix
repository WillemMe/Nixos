{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.xdg;

in {
    options.modules.xdg = { enable = mkEnableOption "xdg"; };
    config = mkIf cfg.enable {
        xdg = {
            userDirs = {
              enable = true;
              documents = "$HOME/Documents";
              download = "$HOME/Downloads";
              videos = "$HOME/Videos";
              music = "$HOME/Music";
              pictures = "$HOME/Pictures";
              desktop = "$HOME/Desktop";
              publicShare = "$HOME/The Warehouse/public";
              templates = "$HOME/Templates";
          };
          portal = {
              enable = true;
              extraPortals = with pkgs; [
                xdg-desktop-portal-wlr
                xdg-desktop-portal-gtk
              ];
              config.common.default = "*";

            };
        };
    };
}
